# Nix Environment Configuration

This repository contains Nix configurations for separate personal and work environments. The setup uses home-manager to manage user environments and includes various flakes for different purposes.

## Structure

- Personal user environment with dedicated flakes for personal projects and fun tools
- Work user environment with dedicated packages and configuration
- Shared modules for common configuration
- Installation script to set up the environments

## Installation

Run the installation script:

```bash
./install.sh
```

This will:
1. Install Nix if it's not already installed
2. Enable flakes if not already enabled
3. Set up the personal and work environments
4. Link configuration files to the appropriate locations

## Usage

After installation:

- For the personal environment: `home-manager switch --flake .#personal`
- For the work environment: `home-manager switch --flake .#work`

## Customization

You can customize each environment by editing:

- `users/personal/packages.nix` - Add or remove personal packages
- `users/work/packages.nix` - Add or remove work packages
- `users/personal/flakes/*.nix` - Modify personal flakes configuration
- `modules/*.nix` - Adjust shared configurations

## Requirements

- Nix package manager (installed by the script if not present)
- Git (for pulling updates)