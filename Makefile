

# ==========================
# Sentinel Makefile
# ==========================

.DEFAULT_GOAL := help

.PHONY: help install sync update lint format typecheck test check hooks run docker-up docker-down clean

help:
	@echo ""
	@echo "Available commands:"
	@echo "  make install      Install project dependencies"
	@echo "  make sync         Sync dependencies"
	@echo "  make update       Update dependencies"
	@echo "  make lint         Run Ruff lint"
	@echo "  make format       Format code"
	@echo "  make typecheck    Run mypy"
	@echo "  make test         Run pytest"
	@echo "  make check        Run all quality checks"
	@echo "  make hooks        Run pre-commit on all files"
	@echo "  make run          Start API (future)"
	@echo "  make docker-up    Start Docker services (future)"
	@echo "  make docker-down  Stop Docker services"
	@echo "  make clean        Remove cache files"
	@echo ""

install:
	uv sync

sync:
	uv sync

update:
	uv lock --upgrade
	uv sync

lint:
	uv run ruff check .

format:
	uv run ruff format .

typecheck:
	@if find shared src -type f \( -name "*.py" -o -name "*.pyi" \) 2>/dev/null | grep -q .; then \
		uv run mypy shared src; \
	else \
		echo "No Python source files found. Skipping mypy."; \
	fi

test:
	@if [ -d tests ] && find tests -type f \( -name "test_*.py" -o -name "*_test.py" \) | grep -q .; then \
		uv run pytest; \
	else \
		echo "No tests found. Skipping pytest."; \
	fi

check:
	uv run ruff check .
	uv run ruff format --check .
	$(MAKE) typecheck
	$(MAKE) test

hooks:
	uv run pre-commit run --all-files

run:
	@echo "FastAPI service not implemented yet."

docker-up:
	@echo "Docker installation intentionally postponed until Phase 1."

docker-down:
	@echo "Docker not configured yet."

clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name ".ruff_cache" -exec rm -rf {} +
	find . -type d -name ".mypy_cache" -exec rm -rf {} +
