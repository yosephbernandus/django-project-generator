#!/bin/bash
# install.sh

echo "🚀 Installing Django Project Generator..."

# Download script
curl -sSL https://raw.githubusercontent.com/yosephbernandus/django-project-generator/master/django_generate.sh -o /tmp/django_generate.sh

# Make executable and install
chmod +x /tmp/django_generate.sh
sudo mv /tmp/django_generate.sh /usr/local/bin/django_generate

echo "✅ Installed successfully!"
echo "Usage: django_generate"

