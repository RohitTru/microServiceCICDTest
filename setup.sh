#!/bin/bash

# Ensure pip is updated
pip install --upgrade pip

# Get the current feature app folder (assuming it's in the current directory)
APP_DIR="./${APP_NAME:-feature-app}"

# Check if the feature app folder exists, and navigate to it
if [ ! -d "$APP_DIR" ]; then
    echo "❌ Feature app directory $APP_DIR not found. Exiting..."
    exit 1
fi

cd "$APP_DIR" || exit

# Create and activate virtual environment in the feature branch directory
VENV_DIR="venv"
if [ ! -d "$VENV_DIR" ]; then
    echo "🚀 Creating virtual environment in $APP_DIR..."
    python3 -m venv "$VENV_DIR"
    echo "✅ Virtual environment created!"
else
    echo "✅ Virtual environment already exists!"
fi

# Activate the virtual environment
source "$VENV_DIR/bin/activate"

# Install dependencies from the requirements.txt in the feature branch
pip install -r requirements.txt || echo "⚠️ Failed to install requirements!"

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

echo "✅ Virtual environment set up and ready to go!"
