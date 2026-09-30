### 🎯 Problem Statement / Learning Objective
Modern engineering demands versatility: serving server-side rendered (SSR) web pages for SEO and immediate browser access, alongside decoupled REST APIs consumed by mobile apps and third-party services. In this milestone, learners work inside `labs/week-02-apis-ssr/starter/` to build a hybrid application combining Django Class-Based Views (CBVs), custom context processors, template filters, and Django REST Framework (DRF) with Session and JWT authentication.

### 📋 Step-by-Step Instructions
1. **Set Up Your Workspace**:
   - Claim this issue by commenting `.take` on GitHub.
   - Create your feature branch:
     ```bash
     git checkout -b <username>/issue-03-hybrid-platform
     ```
   - Install isolated dependencies:
     ```bash
     make setup lab=02
     ```
2. **Implement Server-Side Rendering (SSR)**:
   - Create Class-Based Views in `events/views.py`: `EventListView`, `EventDetailView`, and `EventCreateView`.
   - Build a custom context processor in `events/context_processors.py` injecting community statistics (e.g., active events in Kigali, total participants) across all templates.
   - Author a custom template filter `rwanda_currency` in `events/templatetags/currency_tags.py` formatting integers into `X,XXX RWF`.
   - Render responsive HTML templates using semantic layouts and CSRF form security.
3. **Build the RESTful API Layer (DRF)**:
   - Configure DRF in `core/settings.py` with standard pagination (`PageNumberPagination`), default permission classes, and throttling.
   - Define serializers in `events/serializers.py`: `EventSerializer` and `RegistrationSerializer` with custom capacity validation.
   - Implement `EventViewSet` in `events/viewsets.py` inheriting from `viewsets.ModelViewSet` with filtering (`django-filter`), search, and ordering.
   - Create custom permission `IsOrganizerOrReadOnly` in `events/permissions.py` granting write operations only to the event creator.
4. **Implement Dual Authentication**:
   - Session authentication for first-party SSR web users with CSRF verification.
   - Stateless JWT authentication via `djangorestframework-simplejwt` for API endpoints (`/api/v1/token/`, `/api/v1/token/refresh/`, `/api/v1/events/`).

### 📦 Deliverables
A pull request opened from your fork targeting the community repository (with label `cohort-review`), containing:
- SSR templates, context processors, and template tags.
- DRF Serializers, ViewSets, and URL routing in `labs/week-02-apis-ssr/starter/`.
- Integration tests validating both HTML status codes and JSON REST responses.

### 📚 DSF Official Documentation
- [Django Class-Based Views](https://docs.djangoproject.com/en/5.1/topics/class-based-views/)
- [Custom Template Tags and Filters](https://docs.djangoproject.com/en/5.1/howto/custom-template-tags/)
- [User Authentication in Django](https://docs.djangoproject.com/en/5.1/topics/auth/default/)
- [Django REST Framework Documentation](https://www.django-rest-framework.org/)
- [DRF Serializers & Validation](https://www.django-rest-framework.org/api-guide/serializers/)
- [DRF ViewSets & Routers](https://www.django-rest-framework.org/api-guide/viewsets/)

### ✅ Acceptance Criteria & Verification Commands
```bash
# 1. Format and lint your lab workspace
make lint lab=02

# Or explicitly:
ruff check labs/week-02-apis-ssr/
ruff format --check labs/week-02-apis-ssr/

# 2. Run automated test suite for Week 2
make test lab=02

# Or explicitly:
pytest labs/week-02-apis-ssr/tests/
```
