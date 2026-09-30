### 🎯 Problem Statement / Learning Objective
Before starting feature development, an open-source educational monorepo must provide an isolated developer experience to prevent merge conflicts and environment crashes across multiple contributors. The objective of this sprint is to initialize the repository's root developer tooling, configure strict linting (`ruff`), configure static type checking (`mypy`), set up automated testing (`pytest-django`), configure isolated lab environments, and establish GitHub Actions CI with automated issue assignment.

### 📋 Step-by-Step Instructions
1. **Initialize Root Quality Tooling (`pyproject.toml`)**:
   - Configure Ruff linter and formatter targeting Python 3.12 with rules for pyflakes, pycodestyle, isort, and bugbear.
   - Configure Mypy with `django-stubs` and `djangorestframework-stubs` in strict mode.
   - Configure Pytest with `testpaths = ["labs"]` avoiding colliding global `pythonpath` declarations.
2. **Configure 12-Factor Environment Template (`.env.example`)**:
   - Provide standard environment keys for `DJANGO_SETTINGS_MODULE`, `DEBUG`, `SECRET_KEY`, `ALLOWED_HOSTS`, `DATABASE_URL`, and `REDIS_URL`.
3. **Set Up Scoped Dependency Management**:
   - Create root `requirements-dev.txt` with universal test runners and linters (`pytest`, `ruff`, `mypy`).
   - Create isolated `labs/week-XX-*/requirements.txt` for each milestone to keep early labs lightweight.
4. **Implement Developer Automation (`Makefile`)**:
   - Provide root-anchored targets supporting `make setup lab=01`, `make lint lab=01`, `make test lab=01`, `make reset lab=01`, and `make test-all`.
5. **Configure GitHub Actions Automation**:
   - Author `.github/workflows/lint-and-test.yml` to dynamically detect modified labs via git diff and only test changed directories.
   - Author `.github/workflows/issue-assign.yml` using `actions-cool/issues-helper@v3` to auto-assign issues upon `.take` comments.
6. **Document Contribution Rules (`CONTRIBUTING.md`)**:
   - Detail the fork-and-branch PR lifecycle, `cohort-review` PR tagging, and the pristine `main` template policy.

### 📦 Deliverables
A pull request containing the initialized repository foundation: `pyproject.toml`, `.env.example`, `requirements-dev.txt`, `Makefile`, `CONTRIBUTING.md`, and `.github/workflows/`.

### 📚 DSF Official Documentation
- [Django Settings Configuration](https://docs.djangoproject.com/en/5.1/topics/settings/)
- [Testing in Django](https://docs.djangoproject.com/en/5.1/topics/testing/)
- [Django Coding Style](https://docs.djangoproject.com/en/dev/internals/contributing/writing-code/coding-style/)

### ✅ Acceptance Criteria & Verification Commands
```bash
# 1. Format and lint verification
ruff check .
ruff format --check .

# 2. Type analysis verification
mypy --version

# 3. Test runner execution across all labs in sequence
make test-all

# 4. GitHub Actions workflows syntax check
python3 -c "import yaml; [yaml.safe_load(open(p)) for p in ['.github/workflows/lint-and-test.yml', '.github/workflows/issue-assign.yml']]"
```
