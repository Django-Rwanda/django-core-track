### 🎯 Problem Statement / Learning Objective
Django's Object-Relational Mapper (ORM) provides powerful database abstractions, but naive query construction frequently leads to the catastrophic N+1 query anti-pattern in production. In this milestone, learners work inside an isolated workspace to construct a Community Event Directory, enforce relational integrity via model constraints, customize the Django Admin for operational productivity, and benchmark query count reduction using eager loading (`select_related` and `prefetch_related`).

### 📋 Step-by-Step Instructions
1. **Set Up Your Workspace**:
   - Claim this issue by commenting `.take` to trigger the automated assignment bot.
   - Create your feature branch:
     ```bash
     git checkout -b <username>/issue-02-event-models
     ```
   - Install isolated dependencies:
     ```bash
     make setup lab=01
     ```
2. **Implement Domain Models (`labs/week-01-mvt-core/starter/events/models.py`)**:
   - Define relational entities: `Category`, `Organizer`, `Venue`, `Event`, and `Registration`.
   - Add database constraints to the `Event` model:
     - `CheckConstraint(check=Q(end_time__gt=F('start_time')), name='event_end_after_start')`
     - `UniqueConstraint(fields=['slug', 'organizer'], name='unique_event_slug_per_organizer')`
   - Generate initial migrations:
     ```bash
     python labs/week-01-mvt-core/starter/manage.py makemigrations
     python labs/week-01-mvt-core/starter/manage.py migrate
     ```
3. **Customize the Django Admin (`labs/week-01-mvt-core/starter/events/admin.py`)**:
   - Customize `EventAdmin` with `list_display` (title, organizer, venue, start_time, is_published), `list_filter`, `search_fields`, and `date_hierarchy`.
   - Register a custom batch action: `mark_as_published` with permission checking.
   - Attach a tabular inline for `Registration` within `EventAdmin`.
4. **Implement Query Optimization & Benchmark Roster (`labs/week-01-mvt-core/starter/events/roster.py`)**:
   - Implement `get_full_event_roster()` to fetch all events along with their venues, organizers, and registered attendees.
   - Eliminate N+1 queries by pairing `select_related('venue', 'organizer')` with `prefetch_related('registrations__attendee')`.
   - Ensure the automated assertion in `tests/test_lab_01.py` passes, verifying the entire roster loads in exactly 2 SQL queries.

### 📦 Deliverables
A pull request opened from your fork targeting the community repository (with label `cohort-review`), containing:
- Model definitions and migrations in `labs/week-01-mvt-core/starter/events/models.py`.
- Admin configuration in `labs/week-01-mvt-core/starter/events/admin.py`.
- Optimized roster query in `labs/week-01-mvt-core/starter/events/roster.py`.
- Terminal output confirming clean linter and passing test execution.

### 📚 DSF Official Documentation
- [Django Models & Field Reference](https://docs.djangoproject.com/en/5.1/ref/models/fields/)
- [Database Constraints](https://docs.djangoproject.com/en/5.1/ref/models/constraints/)
- [QuerySet API & Eager Loading](https://docs.djangoproject.com/en/5.1/ref/models/querysets/)
- [Database Access Optimization](https://docs.djangoproject.com/en/5.1/topics/db/optimization/)
- [The Django Admin Site](https://docs.djangoproject.com/en/5.1/ref/contrib/admin/)

### ✅ Acceptance Criteria & Verification Commands
```bash
# 1. Format and lint your lab workspace
make lint lab=01

# Or explicitly:
ruff check labs/week-01-mvt-core/
ruff format --check labs/week-01-mvt-core/

# 2. Run automated test suite for Week 1
make test lab=01

# Or explicitly:
pytest labs/week-01-mvt-core/tests/
```
