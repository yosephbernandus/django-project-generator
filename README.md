# Django Project Generator

A command-line tool for create a django projects with modern development practice, environment configuration, also comprehensive tools

## Overview

The Django Project Generator streamlines the process of creating new Django projects by providing:

- 🚀 **Interactive project setup** with intelligent Python/Django version matching
- 🔧 **Modern tooling** with uv package management, Ruff linting, and MyPy type checking
- 🌍 **Production-ready configuration** with environment variables, Redis caching, and Celery support
- 📦 **Comprehensive boilerplate** including APIs, static files, logging, and security best practices
- ⚡ **Zero configuration** - works out of the box with sensible defaults

## Requirements

Before using the Django Project Generator, ensure you have:

### **System Requirements**
- **Operating System**: Linux, macOS, or WSL on Windows
- **Internet Connection**: Required for downloading dependencies and skeleton files

### **Required Tools**
- **[uv](https://docs.astral.sh/uv/)** - Python package installer and resolver
  ```bash
  # Install uv (if not already installed)
  UV Docs: https://docs.astral.sh/uv/getting-started/installation/
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ```
- **git** - Version control system
  ```bash
  # Most systems have git pre-installed, verify with:
  git --version
  ```

### **Optional but Recommended**
- **PostgreSQL** - For production database
- **Redis** - For caching
- **Celery** - For async tasks

## Installation

### **One-Line Installation (Recommended)**

```bash
curl -sSL https://raw.githubusercontent.com/yosephbernandus/django-project-generator/master/install.sh | bash
```

### **Manual Installation**

```bash
# Download the script
curl -O https://raw.githubusercontent.com/yosephbernandus/django-project-generator/master/django_generate.sh

# Make it executable
chmod +x django_generate.sh

# Move to system PATH
sudo mv django_generate.sh /usr/local/bin/django_generate
```

### **Verify Installation**

```bash
# Check if django_generate is available globally
which django_generate

# Run the command
django_generate
```

## Python/Django Version Matrix

The generator automatically selects the appropriate Django version based on your chosen Python version:

| Python Version | Django Version | Status | LTS Support |
|----------------|----------------|---------|-------------|
| **3.8**        | **4.2.8**     | ✅ Stable | ✅ LTS until April 2026 |
| **3.9**        | **4.2.8**     | ✅ Stable | ✅ LTS until April 2026 |
| **3.10**       | **4.2.8**     | ✅ Stable | ✅ LTS until April 2026 |
| **3.11**       | **4.2.8**     | ✅ Stable | ✅ LTS until April 2026 |
| **3.12**       | **4.2.8**     | ✅ Stable | ✅ LTS until April 2026 |
| **3.13**       | **5.2**       | ✅ Latest | ✅ LTS until April 2028 |

### **Version Selection Notes**
- **Django 4.2.8** is the current Long Term Support (LTS) release, recommended for production
- **Django 5.2** Long Term Support release, supporting to new python version

## Quick Start

### **1. Generate a New Project**

```bash
django_generate
```

### **2. Follow Interactive Prompts**

```
🚀 Django Project Generator
==========================

📋 Checking system dependencies...
✅ All dependencies found

Enter project name: my awesome blog
📝 Converted 'my awesome blog' → 'my_awesome_blog'
Use 'my_awesome_blog'? (y/n): y

🐍 Select Python version:
1) Python 3.8  → Django 4.2.8
2) Python 3.9  → Django 4.2.8
3) Python 3.10 → Django 4.2.8
4) Python 3.11 → Django 4.2.8
5) Python 3.12 → Django 4.2.8
6) Python 3.13 → Django 5.2
Choose (1-6): 5

📋 Project Summary:
Project Name: my_awesome_blog
Python Version: 3.12
Django Version: 4.2.8

Proceed with project creation? (y/n): y
```

### **3. Start Development**

```bash
cd my_awesome_blog
uv run python src/manage.py migrate
uv run python src/manage.py runserver
```

Visit `http://localhost:8000` to see your new Django project!

## What Gets Generated

### **🏗️ Project Structure**
```
my_awesome_blog/
├── .env                      # Environment variables
├── .env.example             # Environment template
├── pyproject.toml           # Project configuration with Ruff/MyPy
├── src/                     # Django source code
│   ├── config/             # Project settings
│   ├── core/               # Utilities and base classes
│   ├── crud/               # Example API app
│   └── users/              # User management
├── static/                 # Static files (CSS, JS)
├── templates/              # HTML templates
└── logs/                   # Application logs
```

### **⚙️ Pre-configured Features**
- **Environment-based settings** with secure defaults
- **PostgreSQL database** configuration
- **Redis caching** and session management
- **Celery background tasks** with Redis broker
- **Django REST Framework** for APIs
- **CORS headers** for cross-origin requests
- **Comprehensive logging** system
- **Static files handling** with collectstatic

### **🛠️ Development Tools**
- **Ruff** - Lightning-fast Python linter and formatter
- **MyPy** - Static type checking with Django stubs
- **Django Extensions** - Enhanced management commands
- **Health check endpoints** for monitoring

## Troubleshooting

### **Common Issues**

**❌ `uv: command not found`**
```bash
# Install uv
URL: https://docs.astral.sh/uv/getting-started/installation/

curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc  # or restart terminal
```

**❌ `django_generate: command not found`**
```bash
# Reinstall the generator
curl -sSL https://raw.githubusercontent.com/yosephbernandus/django-project-generator/master/install.sh | bash
```

**❌ `Permission denied`**
```bash
# Fix permissions during manual install
chmod +x django_generate.sh
sudo mv django_generate.sh /usr/local/bin/django_generate
```

**❌ Project name with spaces**
```bash
# The generator automatically converts spaces to underscores
# "My Blog" becomes "My_Blog"
```

### **Getting Help**

```bash
# Check installation
which django_generate
uv --version

# Test uv functionality
uv --help

# Verify git installation
git --version
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
