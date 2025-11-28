#!/bin/bash

# Cleanup script for ATS_Project before deployment

echo "Starting cleanup for ATS_Project deployment..."

# Remove Python cache files
echo "Removing Python cache files..."
find . -type d -name "__pycache__" -exec rm -r {} +
find . -type f -name "*.py[co]" -delete
find . -type d -name "*.egg-info" -exec rm -r {} +
find . -type d -name ".pytest_cache" -exec rm -r {} +
find . -type d -name "htmlcov" -exec rm -r {} +

# Remove development database
echo "Removing development database..."
rm -f db.sqlite3
rm -f db.sqlite3-journal

# Remove IDE specific files
echo "Removing IDE and OS specific files..."
rm -rf .idea/
rm -rf .vscode/
rm -f *.swo
rm -f *.swp
rm -f .DS_Store
rm -f Thumbs.db

# Remove build and distribution directories
echo "Removing build and distribution directories..."
rm -rf build/
rm -rf dist/
rm -rf *.egg-info/

# Remove virtual environment if exists
echo "Removing virtual environment if exists..."
rm -rf venv/
rm -rf env/

# Remove any local settings file
echo "Removing local settings files..."
find . -name "local_settings.py" -delete
find . -name "*.log" -delete

echo "Cleanup complete. Your project is ready for deployment!"
echo "Please make sure to backup any important files before proceeding with deployment."
