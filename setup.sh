#!/bin/bash

# Ensure pip is updated
pip install --upgrade pip

# Detect the feature branch directory dynamically
APP_DIR=$(find . -maxdepth 1 -type d -name "feature-*" | head -n 1)

if [ -z "$APP_DIR" ]; then
    echo "❌ No feature app directory found (expected feature-*). Exiting..."
    exit 1
fi

echo "🔍 Detected feature app directory: $APP_DIR"

# Navigate to the feature app directory
cd "$APP_DIR"

# Check if .env exists in the feature app directory
if [ ! -f ".env" ]; then
    echo "❌ .env file not found in $APP_DIR. Exiting..."
    exit 1
fi

# Export environment variables from the feature app's .env file
export $(grep -v '^#' .env | xargs)

# Define the correct virtual environment directory **inside** the feature app
VENV_DIR="./venv"

# Create and activate the virtual environment inside the feature app directory
if [ ! -d "$VENV_DIR" ]; then
    echo "🚀 Creating virtual environment in $VENV_DIR..."
    python3 -m venv "$VENV_DIR"
    echo "✅ Virtual environment created!"
else
    echo "✅ Virtual environment already exists!"
fi

# Activate the virtual environment
source "$VENV_DIR/bin/activate"

# Ensure requirements.txt exists before trying to install dependencies
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt || echo "⚠️ Failed to install requirements!"
else
    echo "⚠️ No requirements.txt found in $APP_DIR. Skipping dependency installation."
fi

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

echo "✅ Virtual environment set up inside $APP_DIR and ready to go!"
