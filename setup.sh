#!/bin/bash

# Ensure pip is updated
pip install --upgrade pip

# Create and activate virtual environment in the feature branch directory
VENV_DIR="venv"
if [ ! -d "$VENV_DIR" ]; then
    echo "🚀 Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
    echo "✅ Virtual environment created!"
else
    echo "✅ Virtual environment already exists!"
fi

# Activate the virtual environment
source "$VENV_DIR/bin/activate"

# Install dependencies from the requirements.txt in the feature branch
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

# Ensure the .pre-commit-config.yml is in the feature branch
FEATURE_BRANCH_PRE_COMMIT_CONFIG=".pre-commit-config.yml"

if [ ! -f "$FEATURE_BRANCH_PRE_COMMIT_CONFIG" ]; then
    echo "❌ .pre-commit-config.yml not found in the feature branch directory. Exiting..."
    exit 1
fi

# Install and activate pre-commit hooks
if [ ! -f .git/hooks/pre-commit ]; then
    pre-commit install
    echo "✅ Pre-commit hooks installed!"
else
    echo "🔄 Pre-commit hooks already installed. Skipping..."
fi

echo "✅ Virtual environment and pre-commit hooks set up successfully!"
