#!/bin/bash

# Check if a notebook name was provided
if [ -z "$1" ]; then
    echo "Error: Please provide a notebook name"
    echo "Usage: ./export_notebook.sh notebook_name"
    exit 1
fi

# Get the notebook name without .py extension if provided
notebook_name=${1%.py}

# Get the directory path
dir_path=$(dirname "$notebook_name")
notebook_base=$(basename "$notebook_name")

# Create public directory and subdirectories if they don't exist
mkdir -p "public/$dir_path"

# Export the notebook to HTML
echo "Exporting $notebook_name.py to HTML..."
uv run marimo export html "$notebook_name.py" -o "public/$notebook_name.html" --sandbox

# Check if the export was successful
if [ $? -eq 0 ]; then
    echo "Successfully exported $notebook_name.py to public/$notebook_name.html"
    # Generate index.html
    echo "Generating index.html..."
    uv run scripts/generate_index.py
else
    echo "Error: Failed to export notebook"
    exit 1
fi 