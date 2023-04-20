#!/usr/bin/env bash
set -eux

export DEBIAN_FRONTEND=noninteractive

#Upgrade pip 
python -m pip install --upgrade pip

# Install Python ML packages
echo 'Installing Python ML packages...'
ML_UTILS=("numpy" "pandas" "scipy" "matplotlib" "seaborn" "scikit-learn" "requests" "plotly")
for util in "${ML_UTILS[@]}"; do
    echo "Installing $util..."
    su - ${_REMOTE_USER} -c "python -m pip install --user --no-cache-dir $util"
done

echo "Done!"
