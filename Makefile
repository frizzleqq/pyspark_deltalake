PACKAGE := sparkdelta

SHELL=/bin/bash
VENV=.venv

ifeq ($(OS),Windows_NT)
	VENV_BIN=$(VENV)/Scripts
else
	VENV_BIN=$(VENV)/bin
endif

.venv:  ## Set up Python virtual environment and install requirements
	python -m venv $(VENV)
	$(MAKE) requirements

.PHONY: requirements
requirements: .venv  ## Install/refresh Python project requirements
	$(VENV_BIN)/python -m pip install --upgrade uv
	$(VENV_BIN)/uv pip install --upgrade .[dev]

.PHONY: format
format:
	$(VENV_BIN)/ruff check $(PACKAGE) tests --fix
	$(VENV_BIN)/ruff format $(PACKAGE) tests

.PHONY: lint
lint:
	$(VENV_BIN)/ruff check $(PACKAGE)
	$(VENV_BIN)/ruff format $(PACKAGE) --check
	$(VENV_BIN)/mypy $(PACKAGE)

.PHONY: test
test:
	$(VENV_BIN)/pytest -vv
