#!/bin/bash

INSTALL_DIR="/usr/local/bin"
TARGET="$INSTALL_DIR/rclone_transfer"

echo "This will remove rclone_transfer from $INSTALL_DIR"

read -p "Proceed with uninstall? [Y/n]: " CONFIRM
CONFIRM=${CONFIRM:-Y}

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo "Uninstall cancelled."
  exit 0
fi

if [ -f "$TARGET" ]; then
  sudo rm "$TARGET"
  echo "✅ rclone_transfer removed successfully."
else
  echo "❌ rclone_transfer not found in $INSTALL_DIR."
fi
