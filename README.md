# Truck Signs API

This repository contains the Dockerized backend (Django REST API) of the Truck Signs project, with a strong focus on containerization, deployment, and backend infrastructure.

For the original project description, business context, and API specifications, please refer to the official documentation:  
[Truck Signs API – Original Project README](https://github.com/Developer-Akademie-GmbH/truck_signs_api/blob/main/README.md)

This repository intentionally contains **backend infrastructure only**.  
The frontend is not part of this project and is expected to consume the API externally.

---

## Table of Contents

- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Project Scope](#project-scope)
- [Prerequisites](#prerequisites)
- [Quickstart](#quickstart)
- [Configuration](#configuration)
- [Environment Variables](#environment-variables)
- [Usage](#usage)
- [Testing Checklist](#testing-checklist)
- [Security Notes](#security-notes)
- [Author](#author)

---

## Tech Stack

- **Backend:** Django 2.2 + Django REST Framework
- **Application Server:** Gunicorn
- **Database:** PostgreSQL 14 (persistent Docker volume)
- **Containerization:** Docker
- **Environment Management:** python-environ (.env)
- **Process Automation:** Bash entrypoint script

---

## Project Scope

This repository contains **only the backend API and admin interface**.

Included:
- REST API endpoints for products, categories, orders, comments, etc.
- Django Admin panel for managing data
- Automated database migrations
- Automated superuser creation via environment variables
- Production-ready Docker image

Not included:
- Frontend / UI application
- Reverse proxy (Nginx, Traefik, etc.)

The API is intended to be consumed by a separate frontend project.

---

## Project Structure

```text
truck_signs_api/
├─ backend/
├─ templates/
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
├─ Truck_Signs_API_Checkliste.pdf
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

## Quickstart

### 1. Connect to your server

```bash
ssh <username>@<server-ip>
```

---

### 2. Clone repository (SSH)

```bash
git clone git@github.com:ognjenmanojlovic/truck_signs_api.git
```

```bash
cd truck_signs_api
```

---

### 3. Prepare environment variables

```bash
cp example.env .env
```

Edit `.env` with your values:
- Django secret key
- Allowed hosts (include your server IP)
- Database credentials
- Superuser credentials

---

### 4. Create Docker network

```bash
docker network create trucksigns-net
```

---

### 5. Create database volume

```bash
docker volume create trucksigns-db
```

---

### 6. Start PostgreSQL database

```bash
docker run -d \
  --name db \
  --network trucksigns-net \
  -e POSTGRES_DB=<db_name> \
  -e POSTGRES_USER=<db_user> \
  -e POSTGRES_PASSWORD=<db_password> \
  -v trucksigns-db:/var/lib/postgresql/data \
  postgres:14
```

---

### 7. Build backend image

```bash
docker build -t truck-signs-api:latest .
```

---

### 8. Start backend container

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

All configuration is handled via **environment variables**.

On container start:
- waits for PostgreSQL
- runs migrations
- collects static files
- creates superuser (if env provided)
- starts Gunicorn on port **8020**

---

## Environment Variables

```env
DEBUG=0
SECRET_KEY=<your_secret_key>

ALLOWED_HOSTS=localhost,127.0.0.1,<your.server.ip>

DB_NAME=<db_name>
DB_USER=<db_user>
DB_PASSWORD=<db_password>
DB_HOST=db
DB_PORT=5432

DJANGO_SUPERUSER_USERNAME=<admin_user>
DJANGO_SUPERUSER_EMAIL=<admin_email>
DJANGO_SUPERUSER_PASSWORD=<admin_password>
```

---

## Usage

### API

```
http://<server-ip>:8020/truck-signs/products/
```

### Admin Panel

```
http://<server-ip>:8020/admin/
```

---

## Testing Checklist

- API container builds successfully
- PostgreSQL container runs correctly
- Migrations executed automatically
- Superuser created automatically
- Admin login works
- API returns JSON
- Data persists after restart
- `.env` not committed

---

## Security Notes

- Never commit `.env`
- Use strong passwords
- Restrict ports
- Set `DEBUG=0`
- Keep dependencies updated
- Configure allowed hosts correctly

---

## Author

**Ognjen Manojlovic**

- GitHub: https://github.com/ognjenmanojlovic  
- LinkedIn: https://www.linkedin.com/in/ognjen-manojlovic  
- Instagram: https://instagram.com/0gisha