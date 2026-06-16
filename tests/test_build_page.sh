#!/bin/bash
set -e

# Ensure pandoc is installed
if ! command -v pandoc &> /dev/null; then
    echo "Pandoc is not installed. Please install it to run these tests."
    exit 1
fi

# Setup temporary directory
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

# Create dummy files
INPUT_MD="$TEST_DIR/test.md"
TEMPLATE_HTML="$TEST_DIR/template.html"
OUTPUT_HTML="$TEST_DIR/output.html"

cat <<EOF > "$INPUT_MD"
# Test Title
This is a test paragraph.
EOF

cat <<EOF > "$TEMPLATE_HTML"
<html>
<body>
  \$body\$
</body>
</html>
EOF

# Path to the script being tested
BUILD_SCRIPT="./scripts/build_page.sh"

echo "Running tests for $BUILD_SCRIPT..."

# --- Happy Path ---
echo "Testing Happy Path..."
if [ ! -f "$BUILD_SCRIPT" ]; then
    echo "Error: $BUILD_SCRIPT does not exist yet."
    exit 1
fi

chmod +x "$BUILD_SCRIPT"
"$BUILD_SCRIPT" "$INPUT_MD" "$TEMPLATE_HTML" "$OUTPUT_HTML"

if [ ! -f "$OUTPUT_HTML" ]; then
    echo "Error: Output HTML file was not created."
    exit 1
fi

if ! grep -q "Test Title" "$OUTPUT_HTML"; then
    echo "Error: Output HTML does not contain expected content."
    exit 1
fi
echo "Happy Path passed!"

# --- Sad Paths ---

echo "Testing Sad Path: Missing input file..."
if "$BUILD_SCRIPT" "$TEST_DIR/nonexistent.md" "$TEMPLATE_HTML" "$OUTPUT_HTML" 2>/dev/null; then
    echo "Error: Script should have failed for missing input file."
    exit 1
fi
echo "Missing input file test passed!"

echo "Testing Sad Path: Exactly 2 arguments..."
if "$BUILD_SCRIPT" "$INPUT_MD" "$TEMPLATE_HTML" 2>/dev/null; then
    echo "Error: Script should have failed for providing only 2 arguments."
    exit 1
fi
echo "2 arguments test passed!"

echo "Testing Sad Path: Exactly 4 arguments..."
if "$BUILD_SCRIPT" "$INPUT_MD" "$TEMPLATE_HTML" "$OUTPUT_HTML" "extra_arg" 2>/dev/null; then
    echo "Error: Script should have failed for providing 4 arguments."
    exit 1
fi
echo "4 arguments test passed!"

echo "All tests passed successfully!"
