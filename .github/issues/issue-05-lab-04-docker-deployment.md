### 🎯 Problem Statement / Learning Objective
Transitioning a Django project from local development to production requires separating responsibilities: executing Python through a multi-threaded pre-fork WSGI server, terminating SSL/buffering requests with a high-performance reverse proxy, offloading static and media assets to the filesystem, and orchestrating dependencies with persistent storage. In this milestone, learners work inside `labs/week-04-docker-deploy/starter/` to package Django into a lean, non-root multi-stage Docker image, configure Nginx, set up Gunicorn, and orchestrate the full stack via Docker Compose with automated health checks.

### 📋 Step-by-Step Instructions
1. **Set Up Your Workspace**:
   - Claim this issue by commenting `.take` on GitHub.
   - Create your feature branch:
     ```bash
     git checkout -b <username>/issue-05-docker-deploy
     ```
   - Install isolated dependencies:
     ```bash
     make setup lab=04
     ```
2. **Author Multi-Stage Dockerfile (`Dockerfile`)**:
   - **Stage 1 (Builder)**: Base image `python:3.12-slim-bookworm`, install build compilers (`gcc`, `libpq-dev`), create binary wheels for all requirements.
   - **Stage 2 (Runner)**: Lean runtime, copy wheels and install without build dependencies, create unprivileged system user `appuser` (UID 1001), chown app directories, expose port 8000.
   - Ensure the final image size is strictly under 180MB.
3. **Author Robust Container Entrypoint (`entrypoint.sh`)**:
   - Verify PostgreSQL connectivity using `pg_isready` or Python script before attempting startup.
   - Execute database migrations automatically: `python manage.py migrate --noinput`.
   - Collect static assets: `python manage.py collectstatic --noinput`.
   - Exec command passed as container arguments (`exec "$@"`).
4. **Configure Nginx Reverse Proxy (`nginx/default.conf`)**:
   - Reverse proxy client requests to Gunicorn on `web:8000`.
   - Route `/static/` and `/media/` directly from persistent shared volumes.
   - Configure proxy headers (`Host`, `X-Forwarded-For`, `X-Forwarded-Proto`).
5. **Orchestrate Stack via Docker Compose (`docker-compose.yml`)**:
   - Configure 4 isolated services:
     1. `db`: PostgreSQL 16 with healthcheck and persistent named volume.
     2. `redis`: Redis 7 in-memory cache and task broker.
     3. `web`: Django application running under Gunicorn (`workers = (2 * CPU) + 1`).
     4. `nginx`: Alpine Nginx reverse proxy exposed on port 80.
   - Configure dependency order using `depends_on` with service health conditions.

### 📦 Deliverables
A pull request opened from your fork targeting the community repository (with label `cohort-review`), containing:
- Multi-stage `Dockerfile` and `entrypoint.sh`.
- Nginx configuration in `nginx/default.conf`.
- `docker-compose.yml` with healthchecks.
- Terminal log verifying healthy containers and HTTP 200 responses.

### 📚 DSF Official Documentation
- [How to Deploy Django](https://docs.djangoproject.com/en/5.1/howto/deployment/)
- [How to use Django with Gunicorn](https://docs.djangoproject.com/en/5.1/howto/deployment/wsgi/gunicorn/)
- [Managing Static Files in Production](https://docs.djangoproject.com/en/5.1/howto/static-files/deployment/)
- [Deployment Checklist & Security Settings](https://docs.djangoproject.com/en/5.1/howto/deployment/checklist/)

### ✅ Acceptance Criteria & Verification Commands
```bash
# 1. Run smoke tests via Makefile from repository root
make test lab=04

# Manual container verification:
# 2. Build and verify image size (< 180MB)
docker build -t django-rwanda-app:prod labs/week-04-docker-deploy/starter/
docker images django-rwanda-app:prod --format "{{.Size}}"

# 3. Verify non-root user execution inside container
docker run --rm django-rwanda-app:prod whoami | grep appuser

# 4. Launch full stack & verify health
cd labs/week-04-docker-deploy/starter/
docker compose up -d --build
docker compose ps

# 5. Verify HTTP 200 response and static asset delivery
curl -I http://localhost:80/
curl -I http://localhost:80/static/admin/css/base.css
```
