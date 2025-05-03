#!/bin/sh

set -e  # Exit immediately if a command exits with a non-zero status

# Wait for DB to be ready
# echo "Waiting for postgres..."
# until nc -z "$DATABASE_HOST" "$DATABASE_PORT"; do
#   sleep 1
# done
# echo "PostgreSQL started"

echo "Running migrations..."
python manage.py migrate --noinput

echo "Checking if superuser exists..."
python manage.py shell <<EOF
from django.contrib.auth import get_user_model
import os

User = get_user_model()

username = os.environ.get("DJANGO_SUPERUSER_USERNAME", "admin")
email = os.environ.get("DJANGO_SUPERUSER_EMAIL", "admin@example.com")
password = os.environ.get("DJANGO_SUPERUSER_PASSWORD", "adminpass")

if not User.objects.filter(username=username).exists():
    print("Creating superuser...")
    User.objects.create_superuser(username=username, email=email, password=password)
else:
    print("Superuser already exists.")
EOF

echo "Collecting static files..."
python manage.py collectstatic --noinput

# if [ "$DEBUG" = "True" ]; then
#   echo "Starting Django development server..."
#   exec python manage.py runserver 0.0.0.0:8000
# else
echo "Starting Gunicorn production server..."
exec gunicorn app.wsgi:application --bind 0.0.0.0:8000
# fi
