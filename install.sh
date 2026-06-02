#!/usr/bin/env bash

set -e # Exit immediately if a command exits with a non-zero status

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

echo "======================================="
echo " Setting up your development environment"
echo "======================================="

# 1. Ensure GNU Stow is installed
if ! command -v stow &> /dev/null; then
    echo "📦 GNU Stow not found. Attempting to install..."
    
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y stow
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y stow
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm stow
    else
        echo "❌ Could not find a supported package manager (apt, dnf, pacman)."
        echo "Please install GNU Stow manually and re-run this script."
        exit 1
    fi
fi

# 2. Define the packages you want to stow
# Add or remove folder names here as your repository grows
PACKAGES=(
    "bash"
    "nvim"
)

# 3. Stow the packages
echo "🔗 Creating symlinks with GNU Stow..."
for package in "${PACKAGES[@]}"; do
    if [ -d "$package" ]; then
        echo " -> Stowing $package..."
        # The -R option rests any broken links or updates changed structures
        stow -R "$package"
    else
        echo "⚠️  Warning: Folder '$package' not found in dotfiles directory. Skipping."
    fi
done

echo "🎉 Setup complete! Your configurations are linked."
