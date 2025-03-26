#!/bin/bash

# Function to generate a cryptographically secure random password
generate_password() {
    tr -dc A-Za-z0-9 </dev/urandom | head -c 32
}

# List of environment variables to create
env_vars=(
    "MANYFOLD_DB_PASSWORD"
    "MANYFOLD_DB_ROOT_PASSWORD"
    "MANYFOLD_SECRET"
    "GRAFANA_PASSWORD"
    "GOACCESS_PASSWORD"
    "PROXY_DB_PASSWORD"
    "PROXY_DB_ROOT_PASSWORD"
    "HEDGEDOC_DB_PASSWORD"
    "HEDGEDOC_DB_ROOT_PASSWORD"
    "PAPERLESS_PASSWORD"
    "PAPERLESS_DB_PASSWORD"
    "PAPERLESS_DB_ROOT_PASSWORD"
    "PAPERLESS_SECRET"
)

# Generate and append the environment variables to the .env file
for var in "${env_vars[@]}"; do
    password=$(generate_password)
    echo "$var=\"$password\"" >> .env
    echo "Secrets generated and appended $var to .env file."
done
