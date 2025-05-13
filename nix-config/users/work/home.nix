# Work user configuration

{ config, pkgs, lib, inputs, ... }:

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

  # Base packages for work environment
  home.packages = with pkgs; [
    # Basic CLI utilities
    curl
    wget
    htop
    ripgrep
    fd
    jq
    bat
    exa
    fzf
    
    # Work-specific tools
    slack
  ];

  # Git configuration for work
  programs.git = {
    enable = true;
    userName = "Noah Henderson";
    userEmail = "nhenderson@cloud303.io"; # Use work email
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true; # Different from personal config
      core.autocrlf = "input";
    };
  };

  # Shell configuration - using zsh with Oh My Zsh
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker" "aws" "kubectl" "terraform" ];
      theme = "agnoster"; # Different theme for visual differentiation
    };
    shellAliases = {
      ll = "ls -la";
      update = "home-manager switch --flake $HOME/.config/nixpkgs#work";
      personalenv = "home-manager switch --flake $HOME/.config/nixpkgs#personal";
      
      # Work-specific aliases
      k = "kubectl";
      tf = "terraform";
      aws-login = "aws sso login";
    };
    initExtra = ''
      # Add custom initialization code here
      echo "Welcome to your work environment!"
      
      # Set up work environment variables
      export WORK_PROJECT_DIR="$HOME/work/projects"
      export AWS_PROFILE="work-account"
      
      # Add work-specific bin directories to PATH
      export PATH="$HOME/.local/work/bin:$PATH"
    '';
  };

  # Vim configuration - slightly different from personal
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      set number
      set relativenumber
      set expandtab
      set tabstop=4
      set shiftwidth=4
      set softtabstop=4
      set ignorecase
      set smartcase
      set incsearch
      set hlsearch
      set clipboard+=unnamedplus
      
      " Work-specific configuration
      set colorcolumn=100
      highlight ColorColumn ctermbg=lightgrey guibg=lightgrey
    '';
  };

  # Terminal configuration - different color scheme
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
          background = "#002b36"; # Solarized dark - different from personal
          foreground = "#839496";
        };
      };
    };
  };
  
  # Kubernetes configuration
  programs.k9s.enable = true;
}