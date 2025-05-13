# Personal user configuration without flakes

{ config, pkgs, lib, ... }:

{
  # Import the packages configuration
  imports = [ ./packages.nix ];

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  # Basic configuration
  home.stateVersion = "23.11"; # Please read the comment before changing

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  

  # Git configuration
  programs.git = {
    enable = true;
    userName = "nhenderson";
    userEmail = "nhenderson22@proton.me";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  # Shell configuration - using zsh with Oh My Zsh
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker" "python" "node" "npm" ];
      theme = "robbyrussell";
    };
    shellAliases = {
      ll = "ls -la";
      update = "home-manager switch";
    };
    initExtra = ''
      # Add custom initialization code here
      echo "Welcome to your personal environment!"
      
      # Add development environment variables that were previously in flakes
      export PERSONAL_DEV_DIR="$HOME/projects/personal"
    '';
  };

  # Vim configuration
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      set number
      set relativenumber
      set expandtab
      set tabstop=2
      set shiftwidth=2
      set softtabstop=2
      set ignorecase
      set smartcase
      set incsearch
      set hlsearch
      set clipboard+=unnamedplus
    '';
  };

  # Terminal configuration
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      font = {
        normal.family = "Hack";
        size = 12;
      };
      window = {
        padding = {
          x = 10;
          y = 10;
        };
      };
      colors = {
        primary = {
          background = "#282a36";
          foreground = "#f8f8f2";
        };
      };
    };
  };
  
  # Additional configurations that would integrate content previously in flakes
  xdg.configFile."personal-dev-configs".text = ''
    # Add your personal development configurations here
    export PERSONAL_DEV_DIR="$HOME/projects/personal"
    
    # Add Python virtual environment functions
    create_venv() {
      python -m venv .venv
      source .venv/bin/activate
      pip install --upgrade pip
    }
  '';
  
  # Allow unfree packages (moved here from packages.nix if you also want to remove that file)
  nixpkgs.config.allowUnfree = true;
}