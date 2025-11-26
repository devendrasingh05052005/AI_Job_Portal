#!/usr/bin/env bash
# Exit on error
set -o errexit

# Install dependencies
echo "==> Installing dependencies..."
pip install -r requirements.txt

# Install PostgreSQL client (required for psycopg2)
echo "==> Installing PostgreSQL client..."
sudo apt-get update
sudo apt-get install -y libpq-dev python3-dev

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
