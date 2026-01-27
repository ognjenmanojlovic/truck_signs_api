# Truck Signs API

This repository contains the Dockerized backend (Django REST API) of the Truck Signs project, with a strong focus on containerization, deployment, and backend infrastructure.

For the original project description, business context, and API specifications, please refer to the official documentation:  
[Truck Signs API – Original Project README](https://github.com/Developer-Akademie-GmbH/truck_signs_api/blob/main/README.md)

This repository intentionally contains **backend infrastructure only**.  
The frontend is not part of this project and is expected to consume the API externally.

---

## Table of Contents

- Tech Stack
- Project Structure
- Project Scope
- Prerequisites
- Quickstart (Server)
- Deployment (Server)
- Configuration
- Environment Variables
- Usage
- Testing Checklist
- Security Notes
- Author

---

## Tech Stack

- **Backend:** Django 2.2 + Django REST Framework
- **Application Server:** Gunicorn
- **Database:** PostgreSQL 14 (persistent Docker volume)
- **Containerization:** Docker
- **Environment Management:** python‑environ (.env)
- **Process Automation:** Bash entrypoint script

---

## Project Scope

This repository contains **only the backend API and admin interface**.

Included:
- REST API endpoints for products, categories, orders, comments, etc.
- Django Admin panel for managing data
- Automated database migrations
- Automated superuser creation via environment variables
- Production‑ready Docker image

Not included:
- Frontend / UI application
- Reverse proxy (Nginx, Traefik, etc.)

The API is intended to be consumed by a separate frontend project.

---

## Project Structure

```text
truck_signs_api/
├─ backend/                     # Django application (API logic)
├─ templates/                   # Admin overrides & system templates
├─ truck_signs_designs/
│  ├─ settings/
│  │  ├─ base.py
│  │  ├─ dev.py
│  │  ├─ production.py
│  │  └─ test_docker.py
│  ├─ urls.py
│  └─ wsgi.py
├─ Dockerfile
├─ entrypoint.sh
├─ requirements.txt
├─ manage.py
├─ example.env
├─ README.md
└─ .gitignore
```

---

## Prerequisites

Ensure the following tools are installed:

```bash
docker --version
```

```bash
git --version
```

---

## Quickstart (Server)

### 1. Clone repository

```bash
git clone https://github.com/ognjenmanojlovic/truck_signs_api.git
```

```bash
cd truck_signs_api
```

### 2. Prepare environment variables

```bash
cp example.env .env
```

Edit `.env` and configure:
- Django secret key
- Allowed hosts (include your server IP)
- PostgreSQL credentials
- Django superuser credentials

---

## Deployment (Server)

### 1. Create Docker network (once)

```bash
docker network create trucksigns-net
```

### 2. Start PostgreSQL container

```bash
docker volume create trucksigns-db
```

```bash
docker run -d \
  --name db \
  --network trucksigns-net \
  -e POSTGRES_DB=trucksigns \
  -e POSTGRES_USER=trucksigns \
  -e POSTGRES_PASSWORD=trucksigns \
  -v trucksigns-db:/var/lib/postgresql/data \
  postgres:14
```

### 3. Build API image

```bash
docker build -t truck-signs-api:latest .
```

### 4. Run API container

```bash
docker run -d \
  --name truck-signs-api \
  --network trucksigns-net \
  --env-file .env \
  -p 8020:8020 \
  truck-signs-api:latest
```

---

## Configuration

All configuration is handled via **environment variables** loaded from `.env`.

The container startup process automatically:
- Waits for PostgreSQL
- Applies migrations
- Collects static files
- Creates a Django superuser (if credentials are provided)
- Starts Gunicorn

---

## Environment Variables

```env
DEBUG=0
SECRET_KEY=change_me_secret_key

ALLOWED_HOSTS=localhost,127.0.0.1,<your.server.ip>

DB_NAME=trucksigns
DB_USER=trucksigns
DB_PASSWORD=trucksigns
DB_HOST=db
DB_PORT=5432

DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_EMAIL=admin@example.com
DJANGO_SUPERUSER_PASSWORD=change_me_admin_pass
```

---

## Usage

### Access API

```text
http://<server-ip>:8020/truck-signs/products/
```

### Django Admin Panel

```text
http://<server-ip>:8020/admin/
```

---

## Testing Checklist

- API container builds successfully
- PostgreSQL container starts correctly
- Database migrations applied automatically
- Superuser created automatically
- Admin login works
- API endpoints return JSON responses
- Data persists across container restarts
- `.env` is excluded from Git

---

## Security Notes

- Never commit `.env`
- Use strong, unique passwords
- Restrict exposed ports
- Set `DEBUG=0` in production
- Keep dependencies up to date
- Limit allowed hosts

---

## Author

**Ognjen Manojlovic**

- GitHub: https://github.com/ognjenmanojlovic
- LinkedIn: https://www.linkedin.com/in/ognjen-manojlovic
- Instagram: https://instagram.com/0gisha