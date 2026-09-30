# Django Rwanda: 30-Day Track — Educational Monorepo Implementation Plan

This document outlines the GitHub Project Board configuration, sprint schedule, and complete specifications for all GitHub Issues required to execute the 30-Day Developer Acceleration Track using the **Educational Monorepo Pattern**.

---

## 1. Sprint Schedule & GitHub Project Board Mapping

The 4-week curriculum is broken down into structured, actionable GitHub Issues designed for tracking through a GitHub Projects Kanban board (Columns: `Backlog`, `Ready for Dev`, `In Progress`, `Under Mentor Review`, `Merged`).

| Issue # | Milestone / Week | Title | Recommended Assignee | Labels | Est. Effort | Key Acceptance Criteria Summary |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **#01** | **Sprint 0: Setup** | Repository Scaffold, Tooling & Lab CI Pipeline | Lead DevOps Architect | `devops`, `infra`, `tooling` | 3 pts | Scoped Ruff, Mypy, and Pytest running per lab and on GitHub Actions CI. |
| **#02** | **Week 1: MVT Core** | Lab 01: Event Directory Domain Modeling, Admin & ORM Optimization | Learner / Contributor | `curriculum`, `milestone-lab`, `ready-for-dev`, `week-01` | 5 pts | Models with constraints, customized admin, and query count reduced from 50+ to 2 in `labs/week-01-mvt-core/`. |
| **#03** | **Week 2: APIs & SSR** | Lab 02: Hybrid Platform with SSR Templates & Authenticated DRF API | Learner / Contributor | `curriculum`, `milestone-lab`, `ready-for-dev`, `week-02` | 5 pts | SSR views with context processors/tags, DRF ModelViewSets, Session & JWT auth in `labs/week-02-apis-ssr/`. |
| **#04** | **Week 3: Architecture** | Lab 03: Service/Selector Refactor, Concurrency Locks & Pytest Suite | Learner / Contributor | `curriculum`, `milestone-lab`, `ready-for-dev`, `week-03` | 8 pts | Business logic extracted into Services/Selectors; concurrency test passes with row locks in `labs/week-03-architecture-db/`. |
| **#05** | **Week 4: Deployment** | Lab 04: Multi-Stage Docker Packaging, Gunicorn, Nginx & Compose Stack | Learner / Contributor | `curriculum`, `milestone-lab`, `ready-for-dev`, `week-04` | 8 pts | Lean Dockerfile (<180MB), non-root execution, Nginx reverse proxy, healthy compose up in `labs/week-04-docker-deploy/`. |
| **#06** | **Capstone & Transition** | Capstone Evaluation & Transition to Month 2 (Scale) & Month 3 (DSF) | Lead Maintainer | `curriculum`, `capstone`, `upstream` | 3 pts | Peer code review completed, all lab tests green, upstream `django/django` test suite running. |

---

## 2. GitHub Issue Specifications

The following specifications are formatted as GitHub Issue markdown templates, ready to be created directly in the repository issue tracker.

---

### Issue #01: [Sprint 0] Repository Scaffolding, Tooling & Lab CI Pipeline

#### Problem Statement / Learning Objective
Before starting feature development, an open-source educational repository must provide isolated workspaces for each milestone to prevent merge conflicts among multiple learners. The objective of this sprint is to initialize the repository with scoped linting (`ruff`), static type checking (`mypy`), automated testing (`pytest-django`), and a CI workflow that runs checks scoped to the modified lab workspace.

#### Step-by-Step Lab Instructions
1. Configure `pyproject.toml` with Ruff, Mypy, and Pytest settings supporting isolated lab paths under `labs/`.
2. Create environment template file `.env.example`.
3. Create GitHub Actions workflows:
   - `.github/workflows/lint-and-test.yml`: Runs scoped Ruff linting and Pytest against modified labs.
   - `.github/workflows/issue-assign.yml`: Automated issue assignment upon `.take` comments.
4. Provide a developer `Makefile` with targets:
   - `make setup lab=01`
   - `make lint lab=01`
   - `make test lab=01`
   - `make reset lab=01`
   - `make test-all`
5. Author `CONTRIBUTING.md` documenting branch naming, `.take` issue assignment, pristine `main` policy, and draft PR rules.

#### Code Deliverable / Expected Pull Request
- PR containing `pyproject.toml`, `.env.example`, `Makefile`, `CONTRIBUTING.md`, and `.github/workflows/lint-and-test.yml`.

#### DSF Doc Reading List
- [Django Settings Configuration](https://docs.djangoproject.com/en/5.1/topics/settings/)
- [Testing in Django](https://docs.djangoproject.com/en/5.1/topics/testing/)

#### Acceptance Criteria / Verification Commands
- [ ] Running `ruff check .` passes without errors.
- [ ] Running `pytest` runs across lab test harnesses.
- [ ] GitHub Actions workflow triggers on PRs and only tests modified directories.

---

### Issue #02: [Week 1] Lab 01: Event Directory Domain Modeling, Admin & ORM Optimization

#### Problem Statement / Learning Objective
Django's Object-Relational Mapper (ORM) provides powerful abstractions, but naive usage creates catastrophic N+1 database queries that degrade production performance. Learners will work inside their isolated workspace `labs/week-01-mvt-core/starter/`, implement a modular Community Event Directory, enforce database-level relational constraints, customize the Django Admin, and benchmark query count reduction using `select_related` and `prefetch_related`.

#### Step-by-Step Lab Instructions
1. Navigate to your workspace: `cd labs/week-01-mvt-core/starter/`.
2. Define models in `events/models.py`:
   - `Category`, `Organizer`, `Venue`, `Event`, and `Registration`.
   - Add database constraints to `Event`:
     - `CheckConstraint(check=Q(end_time__gt=F('start_time')), name='event_end_after_start')`
     - `UniqueConstraint(fields=['slug', 'organizer'], name='unique_event_slug_per_organizer')`
3. Register models in `events/admin.py`:
   - Customize `EventAdmin` with `list_display`, `list_filter`, `search_fields`, and `date_hierarchy`.
   - Add custom batch action: `mark_as_published` with permission checks.
   - Use tabular inlines for `Registration` within `EventAdmin`.
4. Implement roster queries inside `events/roster.py`:
   - Optimize querysets using `select_related('venue', 'organizer')` and `prefetch_related('registrations__attendee')`.
   - Pass the automated assertion in `labs/week-01-mvt-core/tests/test_lab_01.py` validating that fetching full rosters executes in exactly 2 database queries.

#### Code Deliverable / Expected Pull Request
- PR from branch `<username>/issue-02-event-models` to `main` modifying only files inside `labs/week-01-mvt-core/starter/`.

#### DSF Doc Reading List
- [Django Models & Field Types](https://docs.djangoproject.com/en/5.1/ref/models/fields/)
- [QuerySet API Reference](https://docs.djangoproject.com/en/5.1/ref/models/querysets/)
- [Database Access Optimization](https://docs.djangoproject.com/en/5.1/topics/db/optimization/)
- [The Django Admin Site](https://docs.djangoproject.com/en/5.1/ref/contrib/admin/)
- [Database Constraints](https://docs.djangoproject.com/en/5.1/ref/models/constraints/)

#### Acceptance Criteria / Verification Commands
```bash
# Recommended: Run via Makefile from repository root
make lint lab=01
make test lab=01

# Or run tools directly from repository root:
ruff check labs/week-01-mvt-core/
ruff format --check labs/week-01-mvt-core/
pytest labs/week-01-mvt-core/tests/
```


---

### Issue #03: [Week 2] Lab 02: Hybrid Platform with SSR Templates & Authenticated DRF REST API

#### Problem Statement / Learning Objective
Modern applications often require hybrid delivery: server-side rendered pages for SEO and first-party web users, alongside decoupled REST APIs for mobile applications and third-party integrations. Learners will work inside `labs/week-02-apis-ssr/starter/` to build a dual-delivery platform combining Django Class-Based Views (CBVs), custom template tags/context processors, and Django REST Framework (DRF) with Session and JWT authentication.

#### Step-by-Step Lab Instructions
1. Navigate to workspace: `cd labs/week-02-apis-ssr/starter/`.
2. Implement the Server-Side Rendered (SSR) layer:
   - Create generic Class-Based Views: `EventListView`, `EventDetailView`, and `EventCreateView`.
   - Build a custom context processor in `events/context_processors.py` exposing community metrics (e.g., active events in Kigali).
   - Author a custom template filter `rwanda_currency` formatting price integers into `X,XXX RWF`.
3. Implement the Decoupled REST API layer using Django REST Framework:
   - Configure DRF settings with standard pagination, filtering, and throttling.
   - Create `EventSerializer` and `RegistrationSerializer` with custom capacity validation.
   - Implement `EventViewSet` inheriting from `ModelViewSet` with search and ordering.
   - Implement custom permission `IsOrganizerOrReadOnly`.
4. Configure dual authentication:
   - Session authentication for SSR web users with CSRF protection.
   - JWT authentication via `djangorestframework-simplejwt` for `/api/v1/` endpoints.

#### Code Deliverable / Expected Pull Request
- PR from branch `<username>/issue-03-hybrid-platform` modifying only files inside `labs/week-02-apis-ssr/starter/`.

#### DSF Doc Reading List
- [Django Class-Based Views](https://docs.djangoproject.com/en/5.1/topics/class-based-views/)
- [Custom Template Tags and Filters](https://docs.djangoproject.com/en/5.1/howto/custom-template-tags/)
- [DRF Serializers & Validation](https://www.django-rest-framework.org/api-guide/serializers/)
- [DRF ViewSets & Routers](https://www.django-rest-framework.org/api-guide/viewsets/)
- [DRF Permissions](https://www.django-rest-framework.org/api-guide/permissions/)

#### Acceptance Criteria / Verification Commands
```bash
# Recommended: Run via Makefile from repository root
make lint lab=02
make test lab=02

# Or run tools directly from repository root:
ruff check labs/week-02-apis-ssr/
ruff format --check labs/week-02-apis-ssr/
pytest labs/week-02-apis-ssr/tests/
```

---

### Issue #04: [Week 3] Lab 03: Business Logic Refactoring via Service/Selector Layer & Pytest Suite

#### Problem Statement / Learning Objective
As Django applications grow, embedding domain logic inside views or models creates brittle code and untraceable bugs. Learners will work inside `labs/week-03-architecture-db/starter/` to refactor legacy procedural code into a decoupled **Service Layer** (writes, atomic transactions) and **Selector Layer** (reads, aggregations), and eliminate race conditions using `F()` expressions and row-level locks (`select_for_update`).

#### Step-by-Step Lab Instructions
1. Navigate to workspace: `cd labs/week-03-architecture-db/starter/`.
2. Implement the **Selector Layer** (`events/selectors.py`):
   - `get_available_events(user, category_slug=None) -> QuerySet[Event]`
   - `get_event_dashboard_metrics(event_id: int) -> dict` utilizing `annotate()`, `aggregate()`, `Count()`, and `Sum()`.
3. Implement the **Service Layer** (`events/services.py`):
   - `register_attendee_for_event(*, event_id: int, user: User) -> Registration`
   - Enforce database transaction atomicity with `transaction.atomic()`.
   - Acquire a pessimistic row lock using `Event.objects.select_for_update().get(id=event_id)` to guarantee available capacity.
   - Atomically increment ticket count using `F('registered_count') + 1`.
   - Defer side-effects (e.g., email notification dispatch) until commit using `transaction.on_commit()`.
4. Verify the test suite in `labs/week-03-architecture-db/tests/`:
   - Unit tests for services with mocks.
   - Concurrency stress test simulating simultaneous registration attempts for limited seats.

#### Code Deliverable / Expected Pull Request
- PR from branch `<username>/issue-04-service-layer` modifying only files inside `labs/week-03-architecture-db/starter/`.

#### DSF Doc Reading List
- [Database Transactions & `on_commit`](https://docs.djangoproject.com/en/5.1/topics/db/transactions/)
- [Query Expressions: `F()` and `Q()`](https://docs.djangoproject.com/en/5.1/ref/models/expressions/)
- [Optimizing Database Access](https://docs.djangoproject.com/en/5.1/topics/db/optimization/)
- [Django Security Settings & Checklist](https://docs.djangoproject.com/en/5.1/howto/deployment/checklist/)

#### Acceptance Criteria / Verification Commands
```bash
# Recommended: Run via Makefile from repository root
make lint lab=03
make test lab=03

# Or run tools directly from repository root:
ruff check labs/week-03-architecture-db/
ruff format --check labs/week-03-architecture-db/
pytest labs/week-03-architecture-db/tests/ -k "test_concurrent_registrations"
pytest --cov=labs/week-03-architecture-db/starter --cov-fail-under=85
```

---

### Issue #05: [Week 4] Lab 04: Multi-Stage Docker Packaging, Gunicorn, Nginx & Compose Stack

#### Problem Statement / Learning Objective
A production Django application requires a robust containerized infrastructure separating application execution, static asset serving, persistent database storage, and caching. Learners will work inside `labs/week-04-docker-deploy/starter/` to author a multi-stage Docker build, configure Nginx as a reverse proxy, set up Gunicorn as the WSGI server, and orchestrate the full stack via Docker Compose with automated health checks.

#### Step-by-Step Lab Instructions
1. Navigate to workspace: `cd labs/week-04-docker-deploy/starter/`.
2. Author multi-stage `Dockerfile`:
   - Stage 1 (Builder): Base image `python:3.12-slim`, install build tools, build wheels.
   - Stage 2 (Runner): Lean runtime, copy wheels, create unprivileged `appuser:1001`, expose port 8000.
3. Author `entrypoint.sh`:
   - Wait for PostgreSQL connection.
   - Run database migrations: `python manage.py migrate --noinput`.
   - Collect static files: `python manage.py collectstatic --noinput`.
   - Exec container command (Gunicorn).
4. Configure Nginx (`nginx/default.conf`):
   - Reverse proxy to `web:8000`.
   - Route `/static/` and `/media/` directly from persistent shared volumes.
5. Author `docker-compose.yml`:
   - Services: `db` (PostgreSQL 16), `redis` (Redis 7), `web` (Gunicorn), and `nginx`.
   - Configure health checks on `db` and `redis`.

#### Code Deliverable / Expected Pull Request
- PR from branch `<username>/issue-05-docker-deploy` modifying only files inside `labs/week-04-docker-deploy/starter/`.

#### DSF Doc Reading List
- [Deploying Django](https://docs.djangoproject.com/en/5.1/howto/deployment/)
- [Using Gunicorn with Django](https://docs.djangoproject.com/en/5.1/howto/deployment/wsgi/gunicorn/)
- [Deployment Checklist](https://docs.djangoproject.com/en/5.1/howto/deployment/checklist/)
- [Serving Static Files in Production](https://docs.djangoproject.com/en/5.1/howto/static-files/deployment/)

#### Acceptance Criteria / Verification Commands
```bash
# Recommended: Run smoke tests via Makefile from repository root
make test lab=04

# Manual container verification:
# 1. Build and verify image size (< 180MB)
docker build -t django-rwanda-app:prod labs/week-04-docker-deploy/starter/
docker images django-rwanda-app:prod --format "{{.Size}}"

# 2. Verify non-root user execution inside container
docker run --rm django-rwanda-app:prod whoami | grep appuser

# 3. Launch stack & test health
cd labs/week-04-docker-deploy/starter/
docker compose up -d --build
docker compose ps
curl -I http://localhost:80/
```

---

### Issue #06: [Capstone] Track Retrospective, Portfolio Review & DSF Core Contribution Readiness

#### Problem Statement / Learning Objective
Consolidate all competencies acquired over the 30-day track, complete an end-to-end peer review, and prepare learners for progression into Month 2 (Senior Backend Systems) and Month 3 (Contributing to Django Core / DSF).

#### Step-by-Step Instructions
1. **Run Full Verification Suite**:
   Verify that all individual lab test suites pass locally in sequence:
   ```bash
   make test-all
   ```
2. **Capstone Portfolio Compilation**:
   - Compile links to your completed PRs for Labs 01 through 04.
   - Prepare a brief summary (or 5-minute video) walking through your service-layer design in Week 3 and Docker Compose setup in Week 4.
3. **Setup Upstream Django Development Environment**:
   Fork `django/django` on GitHub and clone locally:
   ```bash
   git clone https://github.com/<your-username>/django.git django-upstream
   cd django-upstream
   python3 -m venv .venv-upstream
   source .venv-upstream/bin/activate
   pip install -e .
   pip install -r tests/requirements/py3.txt
   ```
4. **Run the Upstream Test Suite**:
   Execute Django's internal test suite for a specific module:
   ```bash
   python tests/runtests.py model_fields
   ```
5. **Register on Django Trac**:
   Create an account on the [Django Trac Issue Tracker](https://code.djangoproject.com/).

#### Deliverables
A comment or PR in the community repository linking your lab PRs, a walkthrough summary, and terminal output confirming a successful local `python tests/runtests.py model_fields` execution.

#### DSF Official Documentation
- [Contributing to Django Overview](https://docs.djangoproject.com/en/dev/internals/contributing/)
- [Writing your first patch for Django](https://docs.djangoproject.com/en/dev/intro/contributing/)
- [Running Django's Test Suite](https://docs.djangoproject.com/en/dev/internals/contributing/writing-code/unit-tests/)
- [Advice for New Contributors](https://docs.djangoproject.com/en/dev/internals/contributing/new-contributors/)

#### Acceptance Criteria / Verification Commands
```bash
# 1. Complete local test verification across all labs
make test-all

# 2. Upstream Django test suite verification
cd django-upstream
python tests/runtests.py model_fields
```

