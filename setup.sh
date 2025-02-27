#!/bin/bash

# Ensure pip is updated
pip install --upgrade pip

# Install dependencies
pip install -r app-template/requirements.txt || echo "⚠️ Failed to install requirements!"

# Ensure pre-commit is installed
if ! command -v pre-commit &> /dev/null; then
    echo "⚠️ pre-commit not found! Installing now..."
    pip install pre-commit
    if ! command -v pre-commit &> /dev/null; then
        echo "❌ ERROR: pre-commit failed to install. Exiting..."
        exit 1
    fi
fi

# Install and activate pre-commit hooks
if [ ! -f .git/hooks/pre-commit ]; then
    pre-commit install
    echo "✅ Pre-commit hooks installed!"
else
    echo "🔄 Pre-commit hooks already installed. Skipping..."
fi
