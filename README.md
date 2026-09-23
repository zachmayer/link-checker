# Project Setup and Usage Guide

## Prerequisites

- **macOS**
- **Homebrew** installed
- **Poetry** installed (`brew install poetry`)
- **Node.js** and **npm** installed (`brew install node`)

## Setup Instructions

0. **Install Poetry and Node.js** (only need to do this once)

   ```zsh
   brew install poetry
   brew install node
   ```

1. **Clone the Repository**

    ```zsh
    git clone https://github.com/TeamDurable/internal-automations
    cd internal-automations
    ```

2. **Install Dependencies**

   ```zsh
   make install
   ```

3. **Run the Link Checker**

   ```zsh
   make run-link-check
   ```

## Available Make Commands

- `make help`: Display available commands.
- `make install`: Install Python and Node.js dependencies.
- `make clean`: Remove generated files and clean the environment.
- `make lint`: Run linters and type checkers.
- `make format`: Auto-format the codebase.
- `make run-link-check`: Run the link checker and generate links.csv.
- `make filter-links`: Filter out specific status codes from links.csv.
- `make aggregate-links`: Aggregate broken links by parent page.
- `make generate-reports`: Generate Markdown reports for GitHub Actions.
- `make poetry-shell`: Open an interactive Poetry shell.
