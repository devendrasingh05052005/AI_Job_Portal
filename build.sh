#!/bin/bash
# Exit on error
set -o errexit

# Install system dependencies
echo "==> Installing system dependencies..."
apt-get update && apt-get install -y --no-install-recommends \
    python3-dev \
    gcc \
    libc-dev \
    libjpeg-dev \
    zlib1g-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
echo "==> Installing Python dependencies..."
pip install --no-cache-dir -r requirements.txt

# Create a .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "==> Creating .env file..."
    echo "DJANGO_ENV=production" > .env
    echo "SECRET_KEY=$(python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())')" >> .env
    echo "ALLOWED_HOSTS=*" >> .env
    echo "DEBUG=False" >> .env
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
