#!/bin/bash

# Load the .env file
if [ -f .env ]; then
    source .env
else
    echo "Error: .env file not found." >&2
    exit 1
fi

# Check if DOMAIN is set
if [ -z "$DOMAIN" ]; then
    echo "Error: DOMAIN is not set in the .env file." >&2
    exit 1
fi

# Append the lines to the .env file
cat <<EOT >> .env
DOMAIN_HEDGEDOC="hedgedoc.${DOMAIN}"
DOMAIN_JELLYFIN="jellyfin.${DOMAIN}"
DOMAIN_PAPERLESS="paperless.${DOMAIN}"
DOMAIN_GRAFANA="grafana.${DOMAIN}"
EOT

echo "Appended domain configurations to .env file."