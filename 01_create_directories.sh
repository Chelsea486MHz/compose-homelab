#!/bin/bash

# Load the .env file
if [ -f .env ]; then
    source .env
else
    echo "Error: .env file not found." >&2
    exit 1
fi

# Check if INFRA_DIR is set
if [ -z "$INFRA_DIR" ]; then
    echo "Error: INFRA_DIR is not set in the .env file." >&2
    exit 1
fi

# Services that will not be running as root
users=(
    "prometheus"
    "grafana"
    "jellyfin"
    "jellyseerr"
    "paperless"
    "heimdall"
    "hedgedoc"
    "privatebin"
    "nextcloud"
    "manyfold"
    "pve_exporter"
)

# For services that will be running as root
extra_dirs=(
    "db_proxy"
    "proxy"
    "data_portainer"
)

# Services that require a DB folder
db_users=(
    "manyfold"
    "hedgedoc"
    "paperless"
)

# Create directories and set ownership
for user in "${users[@]}"; do
    # Create the directory
    user_dir="$INFRA_DIR/$user"
    if mkdir -p "$user_dir"; then
        echo "Directory '$user_dir' created successfully."
    else
        echo "Error: Failed to create directory '$user_dir'." >&2
        continue
    fi

    # Get the UID and GID of the user
    user_id=$(id -u "$user")
    group_id=$(id -g "$user")

    # Set the ownership of the directory
    if sudo chown "$user_id:$group_id" "$user_dir"; then
        echo "Ownership of '$user_dir' set to '$user'."
    else
        echo "Error: Failed to set ownership of '$user_dir'. You may need to check your sudo privileges." >&2
        continue
    fi

    # Write the UID and GID to the .env file
    echo "UID_$user=$user_id" >> .env
    echo "GID_$user=$group_id" >> .env
    echo "UID and GID for '$user' written to .env file."
done

# Create db directories for select users
for db_user in "${db_users[@]}"; do
    # Create the db directory
    db_dir="$INFRA_DIR/db_$db_user"
    if mkdir -p "$db_dir"; then
        echo "Directory '$db_dir' created successfully."
    else
        echo "Error: Failed to create directory '$db_dir'." >&2
        continue
    fi

    # Get the UID and GID of the db_user
    user_id=$(id -u "$db_user")
    group_id=$(id -g "$db_user")

    # Set the ownership of the db directory
    if sudo chown "$user_id:$group_id" "$db_dir"; then
        echo "Ownership of '$db_dir' set to '$db_user'."
    else
        echo "Error: Failed to set ownership of '$db_dir'. You may need to check your sudo privileges." >&2
        continue
    fi
done

# Create extra directories for services running as root
for dir in "${extra_dirs[@]}"; do
    # Create the directory
    extra_dir="$INFRA_DIR/$dir"
    if mkdir -p "$extra_dir"; then
        echo "Directory '$extra_dir' created successfully."
    else
        echo "Error: Failed to create directory '$extra_dir'." >&2
        continue
    fi

    # Set the ownership to root
    if sudo chown root:root "$extra_dir"; then
        echo "Ownership of '$extra_dir' set to root."
    else
        echo "Error: Failed to set ownership of '$extra_dir'. You may need to check your sudo privileges." >&2
        continue
    fi
done