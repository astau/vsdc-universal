#!/usr/bin/env bash
set -eux

# Checks if packages are installed and installs them if not
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt-get update -y
        apt-get -y install --no-install-recommends "$@"
    fi
}

# Create a group and add user 
create_usergroup() {
    if ! cat /etc/group | grep -e "^$1:" > /dev/null 2>&1; then
        groupadd -r $1
    fi
    usermod -a -G $1 ${_REMOTE_USER}
}

# Create folder, change owner and set sticky bit
create_folder(){
    umask 0002
    mkdir -p "$1"
    chown -R "${_REMOTE_USER}:$2" "$1"
    chmod -R g+r+w "$1" 
    find "$1" -type d -print0 | xargs -0 -n 1 chmod g+s
}

# Ensure apt is in non-interactive to avoid prompts
export DEBIAN_FRONTEND=noninteractive

# General requirements
echo 'Installing general dependencies...'
check_packages curl ca-certificates gnupg2 tar make gcc libssl-dev zlib1g-dev libncurses5-dev \
            libbz2-dev libreadline-dev libxml2-dev xz-utils libgdbm-dev tk-dev dirmngr \
            libxmlsec1-dev libsqlite3-dev libffi-dev liblzma-dev uuid-dev 

# Install Python
echo 'Installing Python ...'
check_packages python3 python3-doc python3-pip python3-venv python3-dev python3-tk pipx

# Symlinks
update-alternatives --install /usr/bin/python python /usr/bin/python3 10
update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10
update-alternatives --install /usr/bin/pydoc pydoc /usr/bin/pydoc3 10
update-alternatives --install /usr/bin/python-config python-config /usr/bin/python3-config 10        

#Upgrade pip 
python -m pip install --upgrade pip

# Install Python tools
echo 'Installing Python tools...'
DEFAULT_UTILS=("pylint" "flake8" "autopep8" "black" "yapf" "mypy" "pydocstyle" "pycodestyle" "bandit" "pipenv" "virtualenv" "pytest")
create_usergroup pipx
create_folder "${PIPX_HOME}" pipx
create_folder "${PIPX_BIN_DIR}" pipx
for util in "${DEFAULT_UTILS[@]}"; do
    if ! type ${util} > /dev/null 2>&1; then
        pipx install --system-site-packages --pip-args '--no-cache-dir --force-reinstall' ${util}
    else
        echo "${util} already installed. Skipping."
    fi
done

# Clean up
rm -rf /var/lib/apt/lists/*

echo "Done!"