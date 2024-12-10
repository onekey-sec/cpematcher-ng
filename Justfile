help:
    @just --list

# Install all supported Python versions and dependencies in separate virtualenvs
install-all:
    #!/usr/bin/env bash
    for version in 3.8 3.9 3.10 3.11 3.12 3.13; do \
        run-python-version $version poetry install
    done

# Run tests with all supported Python versions
test-all:
    #!/usr/bin/env bash
    for version in 3.8 3.9 3.10 3.11 3.12 3.13; do
        run-python-version $version python$version -m pytest
    done

# Run checks (lints, formatting)
check:
    pre-commit run --all-files

# Completely wipe the development environment and start from scratch
reset-devenv:
    rm -rf .venvs .direnv .pre-commit-config.yaml .pytest_cache .ruff_cache
