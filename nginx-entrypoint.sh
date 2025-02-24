#!/bin/sh

echo "Substituting environment variables in Nginx config..."
echo "VIRTUAL_HOST: ${VIRTUAL_HOST}"
echo "VIRTUAL_PORT: ${VIRTUAL_PORT}"

# Ensure the environment variables are set
if [ -z "$VIRTUAL_HOST" ] || [ -z "$VIRTUAL_PORT" ]; then
    echo "Error: VIRTUAL_HOST or VIRTUAL_PORT is not set!"
    exit 1
fi

# Substitute environment variables into the Nginx config
envsubst '${VIRTUAL_HOST} ${VIRTUAL_PORT}' < /etc/nginx/conf.d/default.conf > /etc/nginx/conf.d/default.conf.tmp

# Check if the substitution was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to substitute environment variables in default.conf!"
    exit 1
fi

# Replace the original config with the substituted version
mv /etc/nginx/conf.d/default.conf.tmp /etc/nginx/conf.d/default.conf

echo "Environment variables substituted successfully."

exec "$@"
