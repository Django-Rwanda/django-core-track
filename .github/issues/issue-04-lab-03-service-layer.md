### 🎯 Problem Statement / Learning Objective
As Django applications grow, embedding domain business logic directly inside views or overloading models with dozens of helper methods creates brittle code, hidden side-effects, and untraceable concurrency bugs. In this milestone, learners work inside `labs/week-03-architecture-db/starter/` to refactor legacy procedural code into a decoupled **Service Layer** (managing writes, transactions, and state changes) and **Selector Layer** (managing pure queries and aggregations). Learners will also prevent concurrency race conditions using `F()` expressions and row-level locks (`select_for_update`).

### 📋 Step-by-Step Instructions
1. **Set Up Your Workspace**:
   - Claim this issue by commenting `.take` on GitHub.
   - Create your feature branch:
     ```bash
     git checkout -b <username>/issue-04-service-layer
     ```
   - Install isolated dependencies:
     ```bash
     make setup lab=03
     ```
2. **Implement the Selector Layer (`events/selectors.py`)**:
   - Create pure query functions isolating complex database reads:
     - `get_available_events(user, category_slug=None) -> QuerySet[Event]`
     - `get_event_dashboard_metrics(event_id: int) -> dict` utilizing `annotate()`, `aggregate()`, `Count()`, and `Sum()`.
3. **Implement the Service Layer (`events/services.py`)**:
   - Create domain functions orchestrating mutations and business workflows:
     - `register_attendee_for_event(*, event_id: int, user: User) -> Registration`
   - Enforce database transaction atomicity with `transaction.atomic()`.
   - Acquire a pessimistic row-level lock using `Event.objects.select_for_update().get(id=event_id)` to guarantee available seat capacity.
   - Atomically increment ticket counts using `F('registered_count') + 1`.
   - Defer side-effects (e.g., ticket confirmation email dispatch) until the database transaction successfully commits using `transaction.on_commit()`.
4. **Refactor Views to Thin Controllers**:
   - Update API views and endpoints to delegate all business logic to services and selectors, returning clean HTTP/JSON responses.
5. **Implement Comprehensive Pytest Suite (`tests/`)**:
   - Create model factories using `factory_boy`.
   - Write unit tests for services with mocks for email dispatch.
   - Write a concurrency stress test simulating 10 simultaneous registration requests attempting to purchase the last 2 available seats, asserting that exactly 2 succeed and 8 fail gracefully with an `InventoryExhaustedError`.

### 📦 Deliverables
A pull request opened from your fork targeting the community repository (with label `cohort-review`), containing:
- `events/selectors.py` and `events/services.py` modules.
- Refactored views and API endpoints delegating cleanly to the service layer.
- Pytest suite with factories in `tests/factories.py` and concurrency stress tests.
- Test coverage report achieving ≥ 85% branch coverage.

### 📚 DSF Official Documentation
- [Database Transactions & on_commit](https://docs.djangoproject.com/en/5.1/topics/db/transactions/)
- [Query Expressions: F() and Q()](https://docs.djangoproject.com/en/5.1/ref/models/expressions/)
- [Optimizing Database Access](https://docs.djangoproject.com/en/5.1/topics/db/optimization/)
- [Django Security Settings & Checklist](https://docs.djangoproject.com/en/5.1/howto/deployment/checklist/)
- [Testing in Django](https://docs.djangoproject.com/en/5.1/topics/testing/)

### ✅ Acceptance Criteria & Verification Commands
```bash
# 1. Format and lint your lab workspace
make lint lab=03

# Or explicitly:
ruff check labs/week-03-architecture-db/
ruff format --check labs/week-03-architecture-db/

# 2. Run concurrency stress test & service layer tests
make test lab=03

# Or explicitly:
pytest labs/week-03-architecture-db/tests/ -k "test_concurrent_registrations"
pytest --cov=labs/week-03-architecture-db/starter --cov-fail-under=85
```
