#!/bin/bash
set -e

# Navigate to project root
PROJECT_ROOT="/Users/kirby1976/IdeaProjects/staticweb"
cd "$PROJECT_ROOT"

pandoc "constitution/constitution.md" --toc --template="constitution/index.html.template" -o "constitution/index.html"
