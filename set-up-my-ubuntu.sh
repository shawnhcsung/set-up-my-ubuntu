#!/bin/bash

PACKAGES+=(git)
PACKAGES+=(vim)
PACKAGES+=(build-essential)

echo "${PACKAGES[@]}"

sudo apt update -y && \
sudo apt upgrade -y && \
sudo apt auto-remove -y
