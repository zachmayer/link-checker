
# Define the site URL and timeout as environment variables
SITE_URL ?=
TIMEOUT ?= 1000

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  install              - Install the project environment"
	@echo "  clean                - Clean up the project environment"
	@echo "  lint                 - Run linting and type checking"
	@echo "  format               - Auto-format the codebase"
	@echo "  links.csv            - Run link checker on SITE_URL and generate links.csv"
	@echo "  filtered_links.csv   - Filter out specific status codes from links.csv"
	@echo "  aggregated_links.csv - Aggregate broken links by parent page"
	@echo "  generate-reports     - Format CSV files for GitHub Actions display"
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
	uv sync
	npm install

.PHONY: clean
clean:
	rm -rf node_modules .venv __pycache__ .pytest_cache .ruff_cache
	rm -f links.csv filtered_links.csv aggregated_links.csv
	find . -name ".DS_Store" -type f -delete

.PHONY: lint
lint:
	uv run ruff check .
	uv run ruff format --check .
	uv run ty check

.PHONY: format
format:
	uv run ruff check --fix .
	uv run ruff format .

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
	uv run python scripts/filter_links.py $< $@

aggregated_links.csv: filtered_links.csv
	uv run python scripts/aggregate_links.py $< $@

reports/filtered_links.md: filtered_links.csv
	uv run python scripts/format_for_github.py $< $@

reports/aggregated_links.md: aggregated_links.csv
	uv run python scripts/format_for_github.py $< $@

.PHONY: generate-reports
generate-reports:
	rm -f links.csv
	make reports/filtered_links.md
	make reports/aggregated_links.md
