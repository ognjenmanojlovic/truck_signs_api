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
  python manage.py createsuperuser --noinput || true
else
  echo "Superuser env vars not set - skipping createsuperuser."
fi

echo "Starting gunicorn on :8020"
exec gunicorn truck_signs_designs.wsgi:application --bind 0.0.0.0:8020
