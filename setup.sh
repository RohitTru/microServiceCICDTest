#!/bin/bash

# Ensure pip is updated
pip install --upgrade pip

# Ensure we are in the correct directory
APP_DIR="./${APP_NAME:-feature-test3}"  # Using the value from the feature app

# Check if the feature app directory exists
if [ ! -d "$APP_DIR" ]; then
    echo "❌ Feature app directory ./$APP_DIR not found. Exiting..."
    exit 1
fi

# Navigate to the feature app directory
cd "$APP_DIR"

# Check if .env exists in the feature app directory
if [ ! -f ".env" ]; then
    echo "❌ .env file not found in the $APP_DIR directory. Exiting..."
    exit 1
fi

# Export environment variables from the feature app's .env file
export $(grep -v '^#' .env | xargs)

# Create and activate the virtual environment
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

# Install dependencies from the requirements.txt in the feature app
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
