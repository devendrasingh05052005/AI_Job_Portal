#!/bin/bash
# Exit on error
set -o errexit

# Install system dependencies
echo "==> Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y python3-dev libpq-dev

# Create and activate virtual environment
echo "==> Setting up virtual environment..."
python -m venv venv
source venv/bin/activate

# Upgrade pip and setuptools
echo "==> Upgrading pip and setuptools..."
pip install --upgrade pip setuptools wheel

# Install Python dependencies
echo "==> Installing Python dependencies..."
pip install -r requirements.txt

# Create a .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "==> Creating .env file..."
    echo "DJANGO_ENV=production" > .env
    echo "SECRET_KEY=$(python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())')" >> .env
    echo "ALLOWED_HOSTS=*" >> .env
    echo "DEBUG=False" >> .env
    echo "DISABLE_COLLECTSTATIC=0" >> .env
fi

# Load environment variables
set -a
source .env
set +a

# Apply database migrations
echo "==> Running migrations..."
python manage.py migrate --noinput

# Collect static files
echo "==> Collecting static files..."
python manage.py collectstatic --noinput --clear

# Create cache table
echo "==> Creating cache table..."
python manage.py createcachetable

echo "==> Build process completed!"
