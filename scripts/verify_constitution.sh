#!/bin/bash
set -e

# Run the build
./scripts/build_constitution.sh

# Check if the hardcoded TOC is gone
if grep -q 'class="toc-nested"' constitution/index.html; then
    echo "FAIL: Hardcoded .toc-nested class still found in HTML"
    exit 1
fi

# Check if Pandoc generated the TOC (it should be inside <nav class="toc">)
if ! grep -q '<nav class="toc">' constitution/index.html; then
    echo "FAIL: <nav class="toc"> not found"
    exit 1
fi

# Check if there is a nested list in the TOC (Pandoc's TOC generation)
# We check for the presence of multiple <ul> tags in the HTML, which indicates nesting in this context
if ! grep -c '<ul>' constitution/index.html | grep -q '[2-9]'; then
    echo "FAIL: Nested TOC list not found (expected multiple <ul> tags)"
    exit 1
fi

echo "SUCCESS: Constitution TOC generated correctly"
