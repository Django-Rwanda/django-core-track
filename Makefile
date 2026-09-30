.PHONY: help setup setup-all lint format test test-all clean

# ------------------------------------------------------------------------------
# Lab Resolution Helper
# Resolves lab=01, lab=1, lab=week-01-mvt-core to labs/week-01-mvt-core
# ------------------------------------------------------------------------------
ifeq ($(lab),01)
  LAB_DIR := labs/week-01-mvt-core
else ifeq ($(lab),1)
  LAB_DIR := labs/week-01-mvt-core
else ifeq ($(lab),02)
  LAB_DIR := labs/week-02-apis-ssr
else ifeq ($(lab),2)
  LAB_DIR := labs/week-02-apis-ssr
else ifeq ($(lab),03)
  LAB_DIR := labs/week-03-architecture-db
else ifeq ($(lab),3)
  LAB_DIR := labs/week-03-architecture-db
else ifeq ($(lab),04)
  LAB_DIR := labs/week-04-docker-deploy
else ifeq ($(lab),4)
  LAB_DIR := labs/week-04-docker-deploy
else ifdef lab
  LAB_DIR := $(if $(wildcard labs/$(lab)),labs/$(lab),$(if $(wildcard $(lab)),$(lab),labs/week-01-mvt-core))
else
  LAB_DIR := labs/week-01-mvt-core
endif

help:
	@echo "Django Rwanda: 30-Day Developer Acceleration Track"
	@echo ""
	@echo "Standardized Root Commands:"
	@echo "  make setup lab=<01|02|03|04>   Install root dev tools + specific lab dependencies"
	@echo "  make setup-all                 Install root dev tools + all lab dependencies"
	@echo "  make lint lab=<01|02|03|04>    Run ruff check and mypy on specified lab"
	@echo "  make format lab=<01|02|03|04>  Format specified lab code with ruff"
	@echo "  make test lab=<01|02|03|04>    Run pytest on specified lab test harness"
	@echo "  make test-all                  Run pytest across all lab test suites"
	@echo "  make reset lab=<01|02|03|04>   Reset lab starter workspace to pristine template"
	@echo "  make clean                     Remove pycache and test artifacts"

setup:
	pip install --upgrade pip
	pip install -r requirements-dev.txt
	@if [ -f $(LAB_DIR)/requirements.txt ]; then \
		echo "Installing isolated dependencies for $(LAB_DIR)..."; \
		pip install -r $(LAB_DIR)/requirements.txt; \
	fi

setup-all:
	pip install --upgrade pip
	pip install -r requirements-dev.txt
	@for req in labs/week-*/requirements.txt; do \
		echo "Installing $$req..."; \
		pip install -r $$req; \
	done

lint:
	@echo "Linting $(LAB_DIR)..."
	ruff check $(LAB_DIR)/
	ruff format --check $(LAB_DIR)/
	@if [ -d $(LAB_DIR)/starter ]; then \
		mypy $(LAB_DIR)/starter/; \
	fi

format:
	@echo "Formatting $(LAB_DIR)..."
	ruff format $(LAB_DIR)/

test:
	@echo "Testing $(LAB_DIR)..."
	@if [ -d $(LAB_DIR)/tests ]; then \
		pytest $(LAB_DIR)/tests/; \
	else \
		echo "No tests directory found in $(LAB_DIR)"; \
	fi

test-all:
	@echo "Running all lab test suites sequentially in isolated processes..."
	@for lab_dir in labs/week-*; do \
		if [ -d "$$lab_dir/tests" ]; then \
			echo "===================================================="; \
			echo "Executing test suite for: $$lab_dir"; \
			echo "===================================================="; \
			pytest "$$lab_dir/tests/" || exit 1; \
		fi \
	done

clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name ".ruff_cache" -exec rm -rf {} +
	find . -type d -name ".mypy_cache" -exec rm -rf {} +
	find labs -name "db.sqlite3*" -delete

reset:
	@echo "Resetting $(LAB_DIR)/starter to pristine template state..."
	git checkout origin/main -- $(LAB_DIR)/starter/ 2>/dev/null || git checkout HEAD -- $(LAB_DIR)/starter/
	find $(LAB_DIR)/starter/ -name "db.sqlite3*" -delete
	@echo "Clean slate restored for $(LAB_DIR)/starter."

