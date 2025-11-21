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

# Check required dependencies
check_and_install rclone
check_and_install fzf

# --- Install rclone_transfer script ---
chmod +x rclone_transfer

INSTALL_DIR="/usr/local/bin"
read -p "Install to [$INSTALL_DIR]? " REPLY
INSTALL_DIR=${REPLY:-$INSTALL_DIR}

sudo cp rclone_transfer "$INSTALL_DIR/"

# Verify installation
if command -v rclone_transfer >/dev/null 2>&1; then
  echo "✅ rclone_transfer installed successfully!"
  echo "You can now run it from anywhere by typing: rclone_transfer"
else
  echo "❌ Installation failed. Please check permissions."
fi
