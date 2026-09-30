# Contributing to Django Rwanda: 30-Day Developer Acceleration Track

Thank you for contributing to the Django Rwanda Developer Acceleration Track! This repository operates like an authentic open-source engineering organization. To ensure smooth collaboration and prevent merge conflicts across dozens of active learners, all participants follow the contribution standards below.

---

## 1. Contribution & Issue Claiming Rules

1. **Automated Issue Claiming with `.take`**:
   - Navigate to the **GitHub Project Board** or **Issues** tab.
   - Look for unassigned issues tagged `ready-for-dev` or `milestone-lab`.
   - Comment `.take` or `/take` on the issue. Our automated GitHub bot will instantly assign the issue to you, add the `in-progress` label, and post your onboarding checklist.
   - *Fallback*: If the bot is busy, a track mentor will assign you manually upon comment.
2. **One Issue per Contributor**:
   - To keep learning slots open and prevent bottlenecks, contributors can only claim **one issue at a time**.
3. **Branch Naming Standard**:
   - Always branch off the `main` branch with the following format:
     ```bash
     git checkout -b <username>/issue-<number>-<short-description>
     # Example:
     git checkout -b fils/issue-02-event-models
     ```
4. **Isolated Milestone Workspaces**:
   - Work strictly inside the designated `starter/` folder for your assigned milestone:
     - Week 1: `labs/week-01-mvt-core/starter/`
     - Week 2: `labs/week-02-apis-ssr/starter/`
     - Week 3: `labs/week-03-architecture-db/starter/`
     - Week 4: `labs/week-04-docker-deploy/starter/`
   - **Do NOT** modify files outside your assigned lab folder (unless working on repository tooling/Sprint 0).
5. **Draft Pull Requests**:
   - Open a **Draft PR** as soon as your branch is pushed:
     ```text
     Title: [WIP] #<issue-number>: <description>
     Example: [WIP] #02: Implement Event models and admin customization
     ```
   - This allows mentors to review your architectural direction early and provide iterative feedback.
6. **Linking Issues & Pull Request Body**:
   - When marking your PR as ready for review, include the closing keyword:
     ```markdown
     Closes #<issue-number>
     ```
   - Fill out the PR template completely, attaching verification command logs.

---

## 2. Pristine `main` & PR Target Branch Architecture

To ensure every learner always receives a **clean slate** when cloning or pulling `main`, the repository enforces this strict branch lifecycle:

1. **`main` is Protected and Pristine**:
   - `main` serves strictly as the template repository and will **never** merge completed learner solutions into `starter/`.
2. **Fork & Branching Workflow**:
   - Learners fork `https://github.com/django-rwanda/django-core-track` to their personal GitHub account.
   - Create a feature branch in your personal fork: `<username>/issue-<number>-<short-description>`.
   - Open your PR from your fork back to the upstream community repository, tagging it with the `cohort-review` label.
3. **Assessment & Completion Without Overwriting `main`**:
   - Mentors review student PRs and verify green status on the scoped CI quality gates.
   - Approved PRs receive the `verified-solution` label and milestone completion badge.
   - Mentors either close the PR as completed or merge it exclusively into a designated cohort archive branch (e.g., `submissions/cohort-2026-q1`) to preserve `main` for future participants.
4. **Local Workspace Reset**:
   - If you ever need to reset your local lab starter workspace back to the initial template:
     ```bash
     make reset lab=01
     ```

---

## 3. Local Development & Testing Workflow

### Centralized Environment Setup & Dependency Isolation
```bash
# 1. Create and activate a centralized virtual environment
python3 -m venv .venv
source .venv/bin/activate

# 2. Install universal dev tooling + dependencies for your assigned lab:
make setup lab=01

# Or manually:
pip install -r requirements-dev.txt
pip install -r labs/week-01-mvt-core/requirements.txt
```

### Running Scoped Quality Checks (From Repo Root)
You are only tested on the files touched in your assigned milestone:

```bash
# Recommended: Using Makefile shortcuts
make lint lab=01
make test lab=01

# Direct CLI equivalents:
ruff check labs/week-01-mvt-core/
ruff format --check labs/week-01-mvt-core/
mypy labs/week-01-mvt-core/starter/
pytest labs/week-01-mvt-core/tests/
```

---

## 4. Code Quality Standards

Before requesting mentor review:
- [ ] Code is formatted with **Ruff** (`ruff format`).
- [ ] Type hints are applied to function signatures.
- [ ] No hardcoded secrets, raw SQL vulnerabilities, or untracked SQLite files.
- [ ] All lab tests pass cleanly without regressions.
- [ ] Code adheres to official [Django Software Foundation (DSF) coding style](https://docs.djangoproject.com/en/dev/internals/contributing/writing-code/coding-style/).

---

## 5. Code of Conduct

This community enforces the official **[Django Software Foundation Code of Conduct](https://www.djangoproject.com/conduct/)**. We are dedicated to providing a welcoming, inclusive, and harassment-free experience for everyone. Be respectful, constructive in peer reviews, and supportive of fellow learners.
