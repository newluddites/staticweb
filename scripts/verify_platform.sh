#!/bin/bash
set -e

# Run the build using the universal builder
./scripts/build_page.sh "party_platform/platform.md" "party_platform/index.html.template" "party_platform/index.html"

# Check if the output file exists
if [ ! -f "party_platform/index.html" ]; then
    echo "FAIL: party_platform/index.html was not created"
    exit 1
fi

# Check if the output contains the expected content
if ! grep -q "The Party Platform" "party_platform/index.html"; then
    echo "FAIL: Expected title 'The Party Platform' not found in HTML"
    exit 1
fi

if ! grep -q "Coming Soon" "party_platform/index.html"; then
    echo "FAIL: Expected content 'Coming Soon' not found in HTML"
    exit 1
fi

echo "SUCCESS: Party Platform page built correctly"
