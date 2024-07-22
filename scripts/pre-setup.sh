#!/bin/bash

# Function to check if a package is installed
check_package() {
  pacman -Qs $1 > /dev/null
}

# Function to check if yay is installed
check_yay() {
  yay -Qs $1 > /dev/null
}

# Update and upgrade system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install packages via pacman
echo "Installing packages with pacman..."
packages=(
  firefox htop dunst curl wget git rofi polybar i3 lxappearance thunar kate kwrite
  pipewire pavucontrol spotify-adblock nitrogen flameshot picom stow alacritty ark zsh
  openssh lutris ranger vim nano
)
for pkg in "${packages[@]}"; do
  if check_package $pkg; then
    echo "$pkg is already installed."
  else
    sudo pacman -S --noconfirm $pkg
  fi
done

# Install yay if not already installed
if ! command -v yay &> /dev/null; then
  echo "Installing yay..."
  sudo pacman -S --needed git base-devel --noconfirm
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
fi

# Install packages via yay
echo "Installing packages with yay..."
yay_packages=(
  light autotiling catppuccin-cursors-macchiato papirus-folders-catppuccin-git
)
for pkg in "${yay_packages[@]}"; do
  if check_yay $pkg; then
    echo "$pkg is already installed."
  else
    yay -S --noconfirm $pkg
  fi
done

# Clone and set up Polybar themes
echo "Setting up Polybar themes..."
git clone --depth=1 https://github.com/adi1090x/polybar-themes.git
cd polybar-themes
chmod +x setup.sh
./setup.sh
cd ..
rm -rf polybar-themes

# Clone and set up Rofi themes
echo "Setting up Rofi themes..."
git clone --depth=1 https://github.com/adi1090x/rofi.git
cd rofi
chmod +x setup.sh
./setup.sh
cd ..
rm -rf rofi

# Install Oh-My-ZSH
echo "Installing Oh-My-ZSH..."
sh -c "$(wget -O- https://install.ohmyz.sh/)"

echo "All done!"

read -p "Do you want to continue setting up the dotfiles? (Y/n): " response

if [[ "$response" =~ ^([nN][oO]|[nN])$ ]]; then
  echo "Continue setup manually"
  exit 0
else
  echo "Proceeding with the setup..."
fi
chmod +x setup.sh
./setup.sh
