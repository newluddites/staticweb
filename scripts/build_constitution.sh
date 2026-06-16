#!/bin/bash
set -e

# Navigate to project root
PROJECT_ROOT=$(git rev-parse --show-toplevel)
cd "$PROJECT_ROOT"

./scripts/build_page.sh "constitution/constitution.md" "constitution/index.html.template" "constitution/index.html"
