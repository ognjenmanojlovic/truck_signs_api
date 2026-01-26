#!/usr/bin/env bash
set -e

DB_HOST="${DB_HOST:-db}"
DB_PORT="${DB_PORT:-5432}"

echo "Waiting for postgres at ${DB_HOST}:${DB_PORT} ..."

until nc -z "$DB_HOST" "$DB_PORT"; do
  sleep 0.2
done

echo "PostgreSQL is up"

python manage.py migrate --noinput
python manage.py collectstatic --noinput

if [ -n "${DJANGO_SUPERUSER_USERNAME}" ] && [ -n "${DJANGO_SUPERUSER_EMAIL}" ] && [ -n "${DJANGO_SUPERUSER_PASSWORD}" ]; then
  echo "Ensuring superuser exists ..."
  python manage.py createsuperuser --noinput \
    --username "$DJANGO_SUPERUSER_USERNAME" \
    --email "$DJANGO_SUPERUSER_EMAIL" || true

  echo "Setting superuser password ..."
  python manage.py shell -c "from django.contrib.auth import get_user_model; User=get_user_model(); u=User.objects.get(username='${DJANGO_SUPERUSER_USERNAME}'); u.set_password('${DJANGO_SUPERUSER_PASSWORD}'); u.is_staff=True; u.is_superuser=True; u.save()"
else
  echo "Superuser env vars not set - skipping createsuperuser"
fi

echo "Starting gunicorn on :8020"
exec gunicorn truck_signs_designs.wsgi:application --bind 0.0.0.0:8020
