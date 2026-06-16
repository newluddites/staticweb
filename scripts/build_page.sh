#!/bin/bash
set -e

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input_md> <template_html> <output_html>"
    exit 1
fi

INPUT_MD="$1"
TEMPLATE_HTML="$2"
OUTPUT_HTML="$3"

if [ ! -f "$INPUT_MD" ]; then
    echo "Error: Input Markdown file '$INPUT_MD' not found."
    exit 1
fi

if [ ! -f "$TEMPLATE_HTML" ]; then
    echo "Error: Template HTML file '$TEMPLATE_HTML' not found."
    exit 1
fi

pandoc --toc --template="$TEMPLATE_HTML" -o "$OUTPUT_HTML" -- "$INPUT_MD"
