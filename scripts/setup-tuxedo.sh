#!/bin/bash

# Setup TUXEDO OS

export DEBIAN_FRONTEND=noninteractive

# Simple prereqs
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install git ansible-core

# Purge crap that gets in our way
sudo apt-get -y autoclean

# Grab the repo
REPO_DIR=/var/tmp/workstation

if [ -d ${REPO_DIR} ]; then
    cd ${REPO_DIR}
    git pull
else
    git clone https://github.com/ikysil/workstation ${REPO_DIR}
    cd ${REPO_DIR}
fi

bash scripts/preflight-checks.sh
if [ $? != 0 ]; then
    echo "ERROR: You have some issues to address before you can build your system."
    echo "       See the results of the pre-flight tests above to help in"
    echo "       determining what went wrong."
    exit 1
else
    echo "SUCCESS: You're all set!"
    echo ""
    echo "The workstation repo is at ${REPO_DIR}. An example run would be:"
    echo "  ansible-playbook -K --ask-vault-pass -l localhost playbooks/home.yml"
    echo ""
fi
