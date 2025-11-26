#!/bin/bash
# This script runs after the deployment is complete

echo "=== Running post-deployment tasks ==="

# Load environment variables
set -a
source .env
set +a

# Create superuser if it doesn't exist
echo "==> Checking for superuser..."
if [ -z "$(python manage.py shell -c "from django.contrib.auth import get_user_model; User = get_user_model(); print(User.objects.filter(is_superuser=True).count())")" ] || [ "$(python manage.py shell -c "from django.contrib.auth import get_user_model; User = get_user_model(); print(User.objects.filter(is_superuser=True).count())")" -eq 0 ]; then
    echo "==> Creating superuser..."
    echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('admin', 'admin@example.com', 'admin') if not User.objects.filter(username='admin').exists() else None" | python manage.py shell
else
    echo "==> Superuser already exists, skipping..."
fi

# Run any pending migrations (as a safety net)
echo "==> Running any pending migrations..."
python manage.py migrate --noinput

# Clear the cache
echo "==> Clearing cache..."
python manage.py clear_cache

echo "=== Post-deployment tasks completed ==="
