# List of users to create
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

# Function to generate a cryptographically secure random password
generate_password() {
    tr -dc A-Za-z0-9 </dev/urandom | head -c 16
}

# Create users with random passwords and no shell
for user in "${users[@]}"; do
    password=$(generate_password)

    # Attempt to create the user with sudo
    if sudo useradd -m -s /sbin/nologin "$user"; then
        echo "User '$user' created successfully."
    else
        echo "Error: Failed to create user '$user'. You may need to check your sudo privileges." >&2
        continue
    fi

    # Attempt to set the password with sudo
    if echo "$user:$password" | sudo chpasswd; then
        echo "Password for user '$user' set successfully."
    else
        echo "Error: Failed to set password for user '$user'. You may need to check your sudo privileges." >&2
        continue
    fi

    echo "Created user '$user' with password '$password'"
done