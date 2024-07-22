#!/bin/bash

# Function to check if a file exists and back it up if it does
backup_file() {
  if [ -f "$2" ]; then
    mv "$2" "$2.bak"
  fi
}

# Full system update/upgrade
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Check if .dotfiles are present
if [ ! -d "$HOME/.dotfiles" ]; then
  echo "Cloning .dotfiles repository..."
  git clone https://github.com/AllenGXM/.dotfiles.git "$HOME/.dotfiles"
fi

# Copy appropriate files to their destinations
echo "Copying dotfiles..."

declare -A files_to_copy=(
  ["$HOME/.dotfiles/.zshrc"]="$HOME/.zshrc"
  ["$HOME/.dotfiles/.config/alacritty/alacritty.toml"]="$HOME/.config/alacritty/alacritty.toml"
  ["$HOME/.dotfiles/.config/dunst/dunstrc"]="$HOME/.config/dunst/dunstrc"
  ["$HOME/.dotfiles/.config/i3/config"]="$HOME/.config/i3/config"
  ["$HOME/.dotfiles/.config/picom/picom.conf"]="$HOME/.config/picom/picom.conf"
  ["$HOME/.dotfiles/.config/polybar/cuts/colors.ini"]="$HOME/.config/polybar/cuts/colors.ini"
  ["$HOME/.dotfiles/.config/polybar/cuts/config.ini"]="$HOME/.config/polybar/cuts/config.ini"
  ["$HOME/.dotfiles/.config/rofi/launchers/type-4/launcher.sh"]="$HOME/.config/rofi/launchers/type-4/launcher.sh"
  ["$HOME/.dotfiles/.config/rofi/launchers/type-4/style-10.rasi"]="$HOME/.config/rofi/launchers/type-4/style-10.rasi"
  ["$HOME/.dotfiles/.config/rofi/powermenu/type-2/style-6.rasi"]="$HOME/.config/rofi/powermenu/type-2/style-6.rasi"
  ["$HOME/.dotfiles/.config/rofi/powermenu/type-2/powermenu.sh"]="$HOME/.config/rofi/powermenu/type-2/powermenu.sh"
  ["$HOME/.dotfiles/.config/rofi/powermenu/type-2/shared/colors.ini"]="$HOME/.config/rofi/powermenu/type-2/shared/colors.ini"
)

for src in "${!files_to_copy[@]}"; do
  dest="${files_to_copy[$src]}"
  backup_file "$src" "$dest"
  cp "$src" "$dest"
done

echo "Dotfiles setup complete!"
