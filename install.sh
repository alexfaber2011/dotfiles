#!/bin/bash

set -e

echo "📂 Installing dotfiles..."

# Copy dotfiles to home directory
for file in .*; do
    if [[ -f "$file" && "$file" != ".git" && "$file" != ".gitignore" ]]; then
        echo "Copying $file to ~/"
        cp "$file" ~/
    fi
done

# Copy .config directory and its contents
if [[ -d ".config" ]]; then
    echo "Copying .config directory to ~/.config/"
    mkdir -p ~/.config
    cp -r .config/* ~/.config/
fi

echo "✨ Dotfiles installed successfully!"