#!/bin/bash

# --- Dependency check and auto-install ---
check_and_install() {
  local dep=$1
  if ! command -v $dep >/dev/null 2>&1; then
    echo "Error: '$dep' is not installed."
    read -p "Install '$dep' now? [Y/n]: " INSTALL
    INSTALL=${INSTALL:-Y}
    if [[ "$INSTALL" =~ ^[Yy]$ ]]; then
      if command -v apt >/dev/null 2>&1; then
        sudo apt update && sudo apt install -y $dep
      elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y $dep
      elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --noconfirm $dep
      elif command -v brew >/dev/null 2>&1; then
        brew install $dep
      else
        echo "No supported package manager found. Please install $dep manually."
        exit 1
      fi
    else
      echo "Please install '$dep' manually before running this script."
      exit 1
    fi
  fi
}

# --- Check required dependencies ---
check_and_install rclone

# --- Make scripts executable ---
chmod +x rclone_transfer
chmod +x uninstall.sh

# --- Install rclone_transfer globally ---
INSTALL_DIR="/usr/local/bin"
read -p "Install to [$INSTALL_DIR]? " REPLY
INSTALL_DIR=${REPLY:-$INSTALL_DIR}

sudo cp rclone_transfer "$INSTALL_DIR/"

#
