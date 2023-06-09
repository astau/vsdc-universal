#!/usr/bin/env bash
set -eux

# Checks if packages are installed and installs them if not
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt-get update -y
        apt-get -y install --no-install-recommends "$@"
    fi
}

# Ensure apt is in non-interactive to avoid prompts
export DEBIAN_FRONTEND=noninteractive

# Install Node
echo 'Installing Node 20...'
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
check_packages nodejs

# Install Typescript
npm install -g typescript 
npm install -g ts-node 

# Clean up
rm -rf /var/lib/apt/lists/*

echo "Done!"