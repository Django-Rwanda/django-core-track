### 🎯 Problem Statement / Learning Objective
Consolidate all competencies acquired over the 30-day track, complete an end-to-end peer review, and prepare learners for progression into Month 2 (Senior Backend Systems) and Month 3 (Contributing to Django Core / DSF).

### 📋 Step-by-Step Instructions
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

### 📦 Deliverables
A comment or PR in the community repository linking your lab PRs, a walkthrough summary, and terminal output confirming a successful local `python tests/runtests.py model_fields` execution.

### 📚 DSF Official Documentation
- [Contributing to Django Overview](https://docs.djangoproject.com/en/dev/internals/contributing/)
- [Writing your first patch for Django](https://docs.djangoproject.com/en/dev/intro/contributing/)
- [Running Django's Test Suite](https://docs.djangoproject.com/en/dev/internals/contributing/writing-code/unit-tests/)
- [Advice for New Contributors](https://docs.djangoproject.com/en/dev/internals/contributing/new-contributors/)

### ✅ Acceptance Criteria & Verification Commands
```bash
# 1. Complete local test verification across all labs
make test-all

# 2. Upstream Django test suite verification
cd django-upstream
python tests/runtests.py model_fields
```
