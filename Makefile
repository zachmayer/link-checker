
# Define the site URL and timeout as environment variables
SITE_URL ?=
TIMEOUT ?= 1000

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  install            - Install the project environment"
	@echo "  clean              - Clean up the project environment"
	@echo "  lint               - Run linting and type checking"
	@echo "  format             - Auto-format the codebase"
	@echo "  run-link-check     - Run link checker and generate links.csv"
	@echo "  filter-links       - Filter out specific status codes from links.csv"
	@echo "  aggregate-links    - Aggregate broken links by parent page"
	@echo "  generate-reports   - Format CSV files for GitHub Actions display"
	@echo ""
	@echo "Usage:"
	@echo "  make [target]"
	@echo "  Example: make install"
	@echo ""
	@echo "Example for generating reports:"
	@echo "  make generate-reports SITE_URL=https://www.ai-insight-solutions.com"

#### Main commands ####
.PHONY: install
install:
	poetry install
	npm install

.PHONY: clean
clean:
	rm -rf node_modules __pycache__ .pytest_cache .mypy_cache .ruff_cache
	rm -f poetry.lock package-lock.json links.csv filtered_links.csv aggregated_links.csv
	find . -name ".DS_Store" -type f -delete

.PHONY: lint
lint:
	poetry run ruff check scripts/
	poetry run mypy scripts/

.PHONY: format
format:
	poetry run isort scripts/
	poetry run ruff check --fix scripts/
	poetry run black scripts/

links.csv:
	@if [ -z "$(SITE_URL)" ]; then \
		echo "Error: SITE_URL is not set. Please provide a value for SITE_URL."; \
		exit 1; \
	fi
	@if ! npx linkinator "$(SITE_URL)" --recurse \
		--skip "'^(?!.*?$(shell echo "$(SITE_URL)" | sed -E 's#^https?://([^/]+).*#\1#')).*$$'" \
		--timeout=$(TIMEOUT) --verbosity=error --format=csv > $@; then \
		echo "Error: Linkinator command failed. Please check the SITE_URL."; \
		exit 1; \
	fi

filtered_links.csv: links.csv
	poetry run scripts.filter_links.py $< $@

aggregated_links.csv: filtered_links.csv
	poetry run scripts.aggregate_links.py $< $@

reports/filtered_links.md: filtered_links.csv
	poetry run scripts.format_for_github.py $< $@

reports/aggregated_links.md: aggregated_links.csv
	poetry run scripts.format_for_github.py $< $@

.PHONY: generate-reports
generate-reports:
	rm -f links.csv
	make reports/filtered_links.md
	make reports/aggregated_links.md
