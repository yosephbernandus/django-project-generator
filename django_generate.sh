#!/bin/bash

# Django Project Generator
# Usage: ./generate_django_project.sh

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# GitHub repository URL
REPO_URL="https://github.com/yosephbernandus/django-skeleton.git"

echo -e "${BLUE}🚀 Django Project Generator${NC}"
echo "=================================="

# Step 1: Check system dependencies
echo -e "${YELLOW}📋 Checking system dependencies...${NC}"

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo -e "${RED}❌ uv is not installed. Please install uv first.${NC}"
    echo "Visit: https://docs.astral.sh/uv/getting-started/installation/"
    exit 1
fi

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ git is not installed. Please install git first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ All dependencies found${NC}"
echo ""

# Step 2: Get project name
while true; do
    read -p "Enter project name: " PROJECT_NAME_INPUT
    
    # Validate project name
    if [[ -z "$PROJECT_NAME_INPUT" ]]; then
        echo -e "${RED}❌ Project name cannot be empty${NC}"
        continue
    fi
    
    # Convert spaces to underscores
    PROJECT_NAME=$(echo "$PROJECT_NAME_INPUT" | sed 's/ /_/g')
    
    # Show conversion if there were spaces
    if [[ "$PROJECT_NAME_INPUT" != "$PROJECT_NAME" ]]; then
        echo -e "${YELLOW}📝 Converted '$PROJECT_NAME_INPUT' → '$PROJECT_NAME'${NC}"
        read -p "Use '$PROJECT_NAME'? (y/n): " use_converted
        if [[ $use_converted != "y" && $use_converted != "Y" ]]; then
            continue
        fi
    fi
    
    # Check if directory already exists
    if [[ -d "$PROJECT_NAME" ]]; then
        echo -e "${RED}❌ Directory '$PROJECT_NAME' already exists${NC}"
        continue
    fi
    
    break
done

echo ""

# Step 3: Python version selection
echo -e "${YELLOW}🐍 Select Python version:${NC}"
echo "1) Python 3.8  → Django 4.2.8"
echo "2) Python 3.9  → Django 4.2.8" 
echo "3) Python 3.10 → Django 4.2.8"
echo "4) Python 3.11 → Django 4.2.8"
echo "5) Python 3.12 → Django 4.2.8"
echo "6) Python 3.13 → Django 5.2"

while true; do
    read -p "Choose (1-6): " python_choice
    
    case $python_choice in
        1) PYTHON_VERSION="3.8"; DJANGO_VERSION="4.2.8"; break ;;
        2) PYTHON_VERSION="3.9"; DJANGO_VERSION="4.2.8"; break ;;
        3) PYTHON_VERSION="3.10"; DJANGO_VERSION="4.2.8"; break ;;
        4) PYTHON_VERSION="3.11"; DJANGO_VERSION="4.2.8"; break ;;
        5) PYTHON_VERSION="3.12"; DJANGO_VERSION="4.2.8"; break ;;
        6) PYTHON_VERSION="3.13"; DJANGO_VERSION="5.2"; break ;;
        *) echo -e "${RED}❌ Invalid choice. Please choose 1-6.${NC}" ;;
    esac
done

echo ""

# Step 4: Confirmation
echo -e "${BLUE}📋 Project Summary:${NC}"
echo "Project Name: $PROJECT_NAME"
echo "Python Version: $PYTHON_VERSION"
echo "Django Version: $DJANGO_VERSION"
echo ""

read -p "Proceed with project creation? (y/n): " confirm
if [[ $confirm != "y" && $confirm != "Y" ]]; then
    echo -e "${YELLOW}❌ Project creation cancelled.${NC}"
    exit 0
fi

echo ""

# Step 5: Clone repository
echo -e "${YELLOW}📦 Cloning Django boilerplate...${NC}"
git clone --depth 1 $REPO_URL $PROJECT_NAME

if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Failed to clone repository${NC}"
    exit 1
fi

cd $PROJECT_NAME

# Remove original git history
rm -rf .git

# Remove existing uv/python files to start fresh
echo -e "${YELLOW}🧹 Cleaning up existing uv configuration...${NC}"
rm -f uv.lock pyproject.toml .python-version

echo -e "${GREEN}✅ Repository cloned and cleaned successfully${NC}"

# Step 6: Initialize uv project
echo -e "${YELLOW}🔧 Setting up uv project...${NC}"
uv init --name $PROJECT_NAME --python $PYTHON_VERSION

if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Failed to initialize uv project${NC}"
    exit 1
fi

# Add tool configurations to pyproject.toml
echo -e "${YELLOW}⚙️ Adding tool configurations to pyproject.toml...${NC}"
cat >> pyproject.toml << 'EOF'

[tool.ruff]
lint.select = ["I"]  # Enable all imported rules
line-length = 100
target-version = "py312"
# Sort
[tool.ruff.lint.isort]
combine-as-imports = true
force-wrap-aliases = true
# Formater
[tool.ruff.format]
quote-style = "double"
indent-style = "space"
skip-magic-trailing-comma = false

[tool.mypy]
plugins = ["mypy_django_plugin.main"]

[tool.django-stubs]
django_settings_module = "src.config.settings"
EOF

echo -e "${GREEN}✅ UV project initialized and configured${NC}"

# Step 7: Create virtual environment
echo -e "${YELLOW}🐍 Creating Python virtual environment...${NC}"
uv venv --python $PYTHON_VERSION

if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Failed to create virtual environment${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Virtual environment created${NC}"

# Step 8: Install Django
echo -e "${YELLOW}📦 Installing Django $DJANGO_VERSION...${NC}"
uv add django==$DJANGO_VERSION

if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Failed to install Django${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Django installed successfully${NC}"

# Step 9: Install other dependencies
echo -e "${YELLOW}📦 Installing project dependencies...${NC}"

# Check if dependencies.txt exists and install from it
# if [[ -f "dependencies.txt" ]]; then
#     echo -e "${YELLOW}📋 Installing dependencies from dependencies.txt...${NC}"
#     while IFS= read -r line; do
#         # Skip empty lines and comments
#         if [[ -n "$line" && ! "$line" =~ ^[[:space:]]*# ]]; then
#             echo "Installing: $line"
#             uv add "$line"
#         fi
#     done < dependencies.txt
#
#     # Remove dependencies.txt after installation
#     rm -f dependencies.txt
#     echo -e "${GREEN}✅ Dependencies from dependencies.txt installed${NC}"
# else
#     # Fallback to basic dependencies
#     uv add django-environ djangorestframework django-cors-headers
# fi

# Download dependencies.txt from the django-project-generator repository
echo -e "${YELLOW}📋 Downloading dependencies.txt...${NC}"
DEPENDENCIES_URL="https://raw.githubusercontent.com/yosephbernandus/django-project-generator/master/dependencies.txt"


if curl -sSL "$DEPENDENCIES_URL" -o dependencies.txt; then
    echo -e "${GREEN}✅ Dependencies.txt downloaded${NC}"
    
    echo -e "${YELLOW}📋 Installing dependencies from dependencies.txt...${NC}"
    while IFS= read -r line; do
        # Skip empty lines and comments
        if [[ -n "$line" && ! "$line" =~ ^[[:space:]]*# ]]; then
            echo "Installing: $line"
            uv add "$line"
        fi
    done < dependencies.txt
    
    # Remove dependencies.txt after installation
    rm -f dependencies.txt
    echo -e "${GREEN}✅ Dependencies from dependencies.txt installed${NC}"

# Remove any Python files in root directory (from uv init)
echo -e "${YELLOW}🧹 Cleaning up generated Python files...${NC}"
rm -f *.py

if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Failed to install dependencies${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Dependencies installed and cleanup completed${NC}"

# Step 11: Generate fresh Django settings
echo -e "${YELLOW}⚙️ Generating fresh Django settings...${NC}"

# Navigate to src directory
cd src

# Move manage.py to avoid conflict
mv manage.py manage.py.backup

# Create temporary Django project
uv run django-admin startproject config_temp .

if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Failed to generate Django project${NC}"
    cd ..
    exit 1
fi

# Replace only the settings.py file
if [[ -f "config_temp/settings.py" ]]; then
    # Replace settings.py with fresh generated one
    cp config_temp/settings.py config/settings.py
    
    # Fix references from config_temp to config in settings.py
    sed -i 's/config_temp/config/g' config/settings.py
    
    # Remove temporary config directory and backup
    rm -rf config_temp
    rm -f config/settings.py.backup
    
    echo -e "${GREEN}✅ Fresh Django settings.py generated${NC}"
else
    echo -e "${RED}❌ Failed to generate Django settings${NC}"
    cd ..
    exit 1
fi

# Clean up manage.py backup and fix references
rm -f manage.py.backup

# Fix references from config_temp to config in manage.py
if [[ -f "manage.py" ]]; then
    sed -i 's/config_temp/config/g' manage.py
    echo -e "${GREEN}✅ manage.py references updated${NC}"
fi

# Extract SECRET_KEY BEFORE adding environ configuration
echo -e "${YELLOW}🔑 Extracting SECRET_KEY from Django settings...${NC}"
SECRET_KEY_LINE=$(grep "SECRET_KEY = " config/settings.py)
# Extract the value between quotes: 'value' or "value"
SECRET_KEY_VALUE=$(echo "$SECRET_KEY_LINE" | sed -n "s/SECRET_KEY = ['\"]\\(.*\\)['\"].*/\\1/p")

# Go back to project root to create .env
cd ..

# Create .env file from .env.example (in project root)
if [[ -f ".env.example" ]]; then
    echo -e "${YELLOW}📝 Creating .env file from .env.example...${NC}"
    cp .env.example .env
    echo -e "${GREEN}✅ .env file created${NC}"
else
    echo -e "${YELLOW}⚠️ .env.example not found, creating empty .env${NC}"
    touch .env
fi

# Add SECRET_KEY to .env with proper format
if [[ -n "$SECRET_KEY_VALUE" ]]; then
    # Use a temporary file to avoid sed issues with special characters
    if grep -q "^SECRET_KEY=" .env; then
        # Create temp file with replacement
        grep -v "^SECRET_KEY=" .env > .env.tmp
        echo "SECRET_KEY=\"$SECRET_KEY_VALUE\"" >> .env.tmp
        mv .env.tmp .env
    else
        echo "SECRET_KEY=\"$SECRET_KEY_VALUE\"" >> .env
    fi
    echo -e "${GREEN}✅ SECRET_KEY added to .env${NC}"
fi

# Go back to src directory
cd src

# Add environ configuration to settings.py
echo -e "${YELLOW}⚙️ Adding environ configuration to settings.py...${NC}"
sed -i '/^BASE_DIR = /a\
\
import os\
import environ\
env = environ.Env(\
    DEBUG=(bool, False),\
    SECRET_KEY=(str, ""),\
    ALLOWED_HOSTS=(list, []),\
    CSRF_TRUSTED_ORIGINS=(list, []),\
    SERVICE_DOMAIN=(str, ""),\
    DB_APPLICATION_NAME=(str, ""),\
    DB_NAME=(str, ""),\
    DB_USER=(str, ""),\
    DB_PASSWORD=(str, ""),\
    DB_HOST=(str, ""),\
    DB_PORT=(int, 5432),\
    REDIS_USER=(str, ""),\
    REDIS_PASSWORD=(str, ""),\
    REDIS_PORT=(int, 6379),\
    REDIS_HOST=(str, ""),\
    REDIS_DB=(int, 1),\
    REDIS_CACHEOPS_HOST=(str, ""),\
    REDIS_CACHEOPS_PORT=(int, 6379),\
    REDIS_CACHEOPS_PASSWORD=(str, ""),\
    REDIS_CACHEOPS_DB=(int, 1),\
    BROKER_URL=(str, ""),  # Currently using RABBITMQ\
    LOG_PATH=(str, ""),\
    ENVIRONMENT=(str, ""),\
    CORS_ALLOWED_ORIGINS=(list, []),\
    CORS_ALLOWED_ORIGIN_REGEXES=(list, []),\
    MEDIA_ROOT=(str, os.path.join(BASE_DIR, "media")),\
    STATIC_URL=(str, "/static/"),\
    STATIC_ROOT=(str, os.path.join(BASE_DIR, "staticfiles")),\
)\
\
environ.Env.read_env(os.path.join(BASE_DIR.parent, ".env"))\
\
MEDIA_ROOT = env("MEDIA_ROOT")\
CSRF_TRUSTED_ORIGINS: list[str] = env("CSRF_TRUSTED_ORIGINS")\
ENVIRONMENT = env("ENVIRONMENT")\
SERVICE_DOMAIN = env("SERVICE_DOMAIN")\
CORS_ALLOW_CREDENTIALS = True\
CORS_ALLOW_METHODS = [\
    "DELETE",\
    "GET",\
    "OPTIONS",\
    "PATCH",\
    "POST",\
    "PUT",\
]\
DB_APPLICATION_NAME = env("DB_APPLICATION_NAME")\
if not DB_APPLICATION_NAME:\
    DB_APPLICATION_NAME = env("SERVICE_DOMAIN")' config/settings.py

echo -e "${GREEN}✅ Environ configuration added to settings.py${NC}"

# Apply settings modifications
echo -e "${YELLOW}⚙️ Applying Django settings modifications...${NC}"

# Replace core settings to use environment variables
sed -i "s/SECRET_KEY = .*/SECRET_KEY = env('SECRET_KEY')/" config/settings.py
sed -i "s/DEBUG = .*/DEBUG = env('DEBUG')/" config/settings.py
sed -i "s/ALLOWED_HOSTS = .*/ALLOWED_HOSTS = env('ALLOWED_HOSTS')/" config/settings.py

# Fix URL configuration and timezone
sed -i 's/ROOT_URLCONF = .*/ROOT_URLCONF = "config.urls"/' config/settings.py
sed -i 's/TIME_ZONE = .*/TIME_ZONE = "Asia\/Jakarta"/' config/settings.py

# Add apps to INSTALLED_APPS
sed -i '/^INSTALLED_APPS = \[$/,/^\]$/{
    /^\]$/i\    "django_extensions",\
    "rest_framework",\
    "corsheaders",\
    "users",
}' config/settings.py

# Add CORS middleware
sed -i '/^MIDDLEWARE = \[$/,/^\]$/{
    /^\]$/i\    "corsheaders.middleware.CorsMiddleware",
}' config/settings.py

# Replace database configuration
sed -i '/^DATABASES = {$/,/^}$/c\
DATABASES = {\
    "default": {\
        "ENGINE": "django.db.backends.postgresql",\
        "OPTIONS": {\
            "options": "-c search_path=ops,public,sb,hst",\
            "application_name": DB_APPLICATION_NAME,\
        },\
        "NAME": env("DB_NAME"),\
        "USER": env("DB_USER"),\
        "PASSWORD": env("DB_PASSWORD"),\
        "HOST": env("DB_HOST"),\
        "PORT": env("DB_PORT"),\
    }\
}' config/settings.py

echo -e "${GREEN}✅ Django settings modifications applied${NC}"

# Add additional configurations to the end of settings.py
echo -e "${YELLOW}⚙️ Adding logging, caching, and Celery configurations...${NC}"

cat >> config/settings.py << EOF

LOG_PATH = env("LOG_PATH") or BASE_DIR
LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "simple": {"format": "%(asctime)s %(levelname)s %(message)s"},
    },
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
            "formatter": "simple",
        },
        "requests_file": {
            "level": "INFO",
            "class": "logging.handlers.WatchedFileHandler",
            "filename": os.path.join(LOG_PATH, "requests.log"),
            "formatter": "simple",
        },
        "app_file": {
            "level": "INFO",
            "class": "logging.handlers.WatchedFileHandler",
            "filename": os.path.join(LOG_PATH, "app.log"),
            "formatter": "simple",
        },
    },
    "loggers": {
        "django.request": {
            "handlers": ["requests_file"],
            "level": "INFO",
            "propagate": False,
        },
        "django.server": {
            "handlers": ["requests_file"],
            "level": "INFO",
            "propagate": False,
        },
        "users": {
            "handlers": ["app_file"],
            "level": "INFO",
            "propagate": False,
        },
    },
}
REDIS_USER = env("REDIS_USER")
REDIS_PASSWORD = env("REDIS_PASSWORD")
REDIS_HOST = env("REDIS_HOST")
REDIS_PORT = env("REDIS_PORT")
REDIS_DB = env("REDIS_DB")
# /0 is a databases usually we differentiate if there is different redis purpose
CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": f"redis://{REDIS_HOST}:{REDIS_PORT}/{REDIS_DB}",
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
            "PASSWORD": REDIS_PASSWORD,
        },
        "KEY_PREFIX": "$PROJECT_NAME",
    }
}
REDIS_CACHEOPS_HOST = env("REDIS_CACHEOPS_HOST")
REDIS_CACHEOPS_PORT = env("REDIS_CACHEOPS_PORT")
REDIS_CACHEOPS_PASSWORD = env("REDIS_CACHEOPS_PASSWORD")
REDIS_CACHEOPS_DB = env("REDIS_CACHEOPS_DB")
CACHEOPS_DEFAULTS = {"timeout": 60 * 60}
CACHEOPS_REDIS = {
    "host": REDIS_CACHEOPS_HOST,
    "port": REDIS_CACHEOPS_PORT,
    "db": REDIS_CACHEOPS_DB,
    "password": REDIS_CACHEOPS_PASSWORD,
}
CACHEOPS = {
    "app.Model": {"ops": "all", "timeout": 60 * 60 * 24},
}
SESSION_ENGINE = "django.contrib.sessions.backends.cache"
SESSION_CACHE_ALIAS = "default"
CELERY_BROKER_URL = env("BROKER_URL")  # Currently using RABBITMQ
CELERY_RESULT_BACKEND = "rpc://"
CELERY_ACCEPT_CONTENT = ["json", "application/text"]
CELERY_TASK_SERIALIZER = "json"
CELERY_RESULT_SERIALIZER = "json"
CELERY_TIMEZONE = TIME_ZONE

REST_FRAMEWORK = {
    "DEFAULT_RENDERER_CLASSES": [
        "rest_framework.renderers.JSONRenderer",
    ],
}

if DEBUG:
    INSTALLED_APPS.append("drf_spectacular")

    REST_FRAMEWORK.update(
        {
            "DEFAULT_SCHEMA_CLASS": "drf_spectacular.openapi.AutoSchema",
        }
    )

    REST_FRAMEWORK["DEFAULT_RENDERER_CLASSES"].append(
        "rest_framework.renderers.BrowsableAPIRenderer"
    )

    # Spectacular settings
    SPECTACULAR_SETTINGS = {
        "TITLE": "Your API",
        "DESCRIPTION": "Your project API documentation",
        "VERSION": "1.0.0",
        "SERVE_INCLUDE_SCHEMA": False,
        "SWAGGER_UI_SETTINGS": {
            "deepLinking": True,
            "persistAuthorization": True,
            "displayOperationId": True,
        },
    }
EOF

# Fix TEMPLATES DIRS and STATIC settings
sed -i "s/'DIRS': \[\]/'DIRS': [BASE_DIR \/ 'templates']/" config/settings.py
sed -i 's/STATIC_URL = .*/STATIC_URL = env("STATIC_URL")/' config/settings.py
sed -i '/^STATIC_URL = env("STATIC_URL")/a\
STATIC_ROOT = env("STATIC_ROOT")\
STATICFILES_DIRS = [\
    BASE_DIR / "static",\
] # Use this if want to debug locally' config/settings.py

echo -e "${GREEN}✅ Additional configurations added${NC}"

# Update Celery configuration with project name
if [[ -f "config/settings_celery.py" ]]; then
    echo -e "${YELLOW}⚙️ Updating Celery configuration...${NC}"
    sed -i 's/app = Celery("django-skeleton")/app = Celery("'$PROJECT_NAME'")/' config/settings_celery.py
    echo -e "${GREEN}✅ Celery configuration updated${NC}"
fi

cd ..

# Step 12: Initialize new git repository
echo -e "${YELLOW}🔄 Initializing git repository...${NC}"
git init
git add .
git commit -m "Initial commit - Django $DJANGO_VERSION with Python $PYTHON_VERSION"

echo -e "${GREEN}✅ Git repository initialized${NC}"

# Step 13: Final instructions
echo ""
echo -e "${GREEN}🎉 Project created successfully!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. cd $PROJECT_NAME"
echo "2. Configure .env (logs, database, Redis, etc.)"
echo "3. uv run python src/manage.py migrate"
echo "4. uv run python src/manage.py runserver"
echo ""
echo -e "${BLUE}To activate the virtual environment:${NC}"
echo "source .venv/bin/activate"

