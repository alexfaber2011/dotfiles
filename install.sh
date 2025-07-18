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

# Configure tide if fish is available
if command -v fish &> /dev/null; then
    echo "🌊 Configuring Tide prompt..."
    fish -c "tide configure --auto --style=Lean --prompt_colors='True color' --show_time='24-hour format' --lean_prompt_height='Two lines' --prompt_connection=Dotted --prompt_connection_andor_frame_color=Darkest --prompt_spacing=Sparse --icons='Few icons' --transient=Yes"
fi

echo "✨ Dotfiles installed successfully!"