# Project Setup and Usage Guide

## Prerequisites

- **macOS**
- **Homebrew** installed
- **uv** installed (`brew install uv`)
- **Node.js** and **npm** installed (`brew install node`)

## Setup Instructions

0. **Install uv and Node.js** (only need to do this once)

   ```zsh
   brew install uv
   brew install node
   ```

1. **Clone the Repository**

    ```zsh
    git clone https://github.com/zachmayer/link-checker
    cd link-checker
    ```

2. **Install Dependencies**

   ```zsh
   make install
   ```

3. **Run the Link Checker**

   ```zsh
   make generate-reports SITE_URL=https://www.example.com
   ```

## Available Make Commands

- `make help`: Display available commands.
- `make install`: Install Python and Node.js dependencies.
- `make clean`: Remove generated files and clean the environment.
- `make lint`: Run linters and type checkers.
- `make format`: Auto-format the codebase.
- `make links.csv SITE_URL=...`: Run the link checker and generate links.csv.
- `make filtered_links.csv`: Filter out specific status codes from links.csv.
- `make aggregated_links.csv`: Aggregate broken links by parent page.
- `make generate-reports`: Generate Markdown reports for GitHub Actions.
