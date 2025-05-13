#!/usr/bin/env bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}==========================================${NC}"
echo -e "${BLUE}    Nix Environment Setup Script         ${NC}"
echo -e "${BLUE}==========================================${NC}"

# Check if running as root
if [ "$EUID" -eq 0 ]; then
  echo -e "${RED}Please don't run as root. This script should be run as your user.${NC}"
  exit 1
fi

# Get the directory of the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/nixpkgs"
HOME_MANAGER_CONFIG="$HOME/.config/home-manager"

# Check if Nix is installed
echo -e "${YELLOW}Checking if Nix is installed...${NC}"
if ! command -v nix &> /dev/null; then
  echo -e "${YELLOW}Nix is not installed. Installing...${NC}"
  
  # Install Nix
  curl -L https://nixos.org/nix/install | sh
  
  # Source nix
  if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  elif [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  fi
else
  echo -e "${GREEN}Nix is already installed.${NC}"
fi

# Make sure experimental features are enabled for flakes
if [ ! -d "$HOME/.config/nix" ]; then
  mkdir -p "$HOME/.config/nix"
fi

if [ ! -f "$HOME/.config/nix/nix.conf" ] || ! grep -q "experimental-features" "$HOME/.config/nix/nix.conf"; then
  echo -e "${YELLOW}Enabling flakes and nix-command experimental features...${NC}"
  echo "experimental-features = nix-command flakes" >> "$HOME/.config/nix/nix.conf"
else
  echo -e "${GREEN}Flakes already enabled.${NC}"
fi

# Install home-manager if not already installed
echo -e "${YELLOW}Checking for home-manager...${NC}"
if ! command -v home-manager &> /dev/null; then
  echo -e "${YELLOW}Installing home-manager...${NC}"
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  
  # Install home-manager
  nix-shell '<home-manager>' -A install
else
  echo -e "${GREEN}home-manager is already installed.${NC}"
fi

# Create the configuration directories
echo -e "${YELLOW}Setting up configuration directories...${NC}"
mkdir -p "$CONFIG_DIR"
mkdir -p "$HOME_MANAGER_CONFIG"

# Create symbolic links
echo -e "${YELLOW}Creating symbolic links for configuration...${NC}"
if [ -d "$CONFIG_DIR" ]; then
  if [ -L "$CONFIG_DIR" ]; then
    rm "$CONFIG_DIR"
  else
    mv "$CONFIG_DIR" "${CONFIG_DIR}.bak-$(date +%Y%m%d%H%M%S)"
  fi
fi

# Link the entire repository to .config/nixpkgs
ln -sf "$SCRIPT_DIR" "$CONFIG_DIR"

# Select user
echo -e "${BLUE}==========================================${NC}"
echo -e "${BLUE}Select which user to set up:${NC}"
echo -e "${BLUE}1) Personal${NC}"
echo -e "${BLUE}2) Work${NC}"
echo -e "${BLUE}3) Both${NC}"
read -p "Enter your choice (1-3): " USER_CHOICE

case $USER_CHOICE in
  1)
    echo -e "${YELLOW}Setting up personal environment...${NC}"
    nix run home-manager/master -- switch --flake "$CONFIG_DIR#personal"
    ;;
  2)
    echo -e "${YELLOW}Setting up work environment...${NC}"
    nix run home-manager/master -- switch --flake "$CONFIG_DIR#work"
    ;;
  3)
    echo -e "${YELLOW}Setting up both environments...${NC}"
    echo -e "${YELLOW}Setting up personal environment first...${NC}"
    nix run home-manager/master -- switch --flake "$CONFIG_DIR#personal"
    echo -e "${YELLOW}Setting up work environment...${NC}"
    nix run home-manager/master -- switch --flake "$CONFIG_DIR#work"
    ;;
  *)
    echo -e "${RED}Invalid choice. Exiting.${NC}"
    exit 1
    ;;
esac

echo -e "${GREEN}Installation complete!${NC}"
echo -e "${YELLOW}To switch between environments, use:${NC}"
echo -e "${BLUE}  home-manager switch --flake $CONFIG_DIR#personal${NC}"
echo -e "${BLUE}  home-manager switch --flake $CONFIG_DIR#work${NC}"
echo -e "${GREEN}Enjoy your new Nix environment!${NC}"