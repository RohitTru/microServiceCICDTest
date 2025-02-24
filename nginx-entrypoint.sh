#!/bin/sh

echo "Starting Nginx entrypoint script..."

# Function to process each app directory
process_app() {
    APP_ENV_FILE="$1/.env"
    
    if [ -f "$APP_ENV_FILE" ]; then
        echo "Processing environment file: $APP_ENV_FILE"
        # Load environment variables from the .env file
        export $(grep -v '^#' "$APP_ENV_FILE" | xargs)
        
        echo "Detected VIRTUAL_HOST: $VIRTUAL_HOST"
        echo "Detected VIRTUAL_PORT: $VIRTUAL_PORT"

        # Ensure required variables are set
        if [ -z "$VIRTUAL_HOST" ] || [ -z "$VIRTUAL_PORT" ]; then
            echo "Error: VIRTUAL_HOST or VIRTUAL_PORT is not set in $APP_ENV_FILE!"
            return 1
        fi

        # Substitute environment variables into the Nginx config template
        envsubst '${VIRTUAL_HOST} ${VIRTUAL_PORT}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/${APP_NAME}.conf

        # Check if the substitution was successful
        if [ $? -ne 0 ]; then
            echo "Error: Failed to substitute environment variables for $APP_NAME!"
            return 1
        fi

        echo "Nginx config generated for $APP_NAME at /etc/nginx/conf.d/${APP_NAME}.conf"
    else
        echo "No .env file found in $1, skipping..."
    fi
}

# Iterate over app directories and process each one
echo "Scanning for app directories..."
for dir in /app/*; do
    if [ -d "$dir" ]; then
        APP_NAME=$(basename "$dir")
        echo "Found app directory: $APP_NAME"
        process_app "$dir"
    fi
done

# Ensure the final config is in place
if [ ! -f "/etc/nginx/conf.d/default.conf" ]; then
    echo "Warning: No default.conf found, falling back to template."
    envsubst '${VIRTUAL_HOST} ${VIRTUAL_PORT}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf
fi

echo "Reloading Nginx with new configurations..."
nginx -s reload

echo "Nginx entrypoint script completed successfully."

# Execute the main process
exec "$@"
