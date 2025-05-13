# Common configuration shared between personal and work profiles

{ config, pkgs, lib, ... }:

{
  # Common packages that should be available in all profiles
  home.packages = with pkgs; [
    # File utilities
    file
    tree
    unzip
    zip
    gzip
    bzip2
    
    # System utilities
    htop
    btop
    lsof
    pciutils
    usbutils
    which
    
    # Network utilities
    dig
    whois
    curl
    wget
    ssh-tools
    
    # Text utilities
    ripgrep
    fd
    fzf
    bat
    exa
    less
    
    # Text editors
    vim
    neovim
    
    # Development basics
    git
    gnupg
    tmux
    
    # Shell utilities
    zsh
    starship # Cross-shell prompt
    direnv # Directory-specific environment variables
  ];

  # Common home-manager configurations
  programs = {
    # Bash configuration
    bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        ls = "exa";
        cat = "bat";
        find = "fd";
        grep = "rg";
      };
    };
    
    # Tmux configuration
    tmux = {
      enable = true;
      shortcut = "a";
      terminal = "screen-256color";
      escapeTime = 0;
      historyLimit = 50000;
      keyMode = "vi";
      extraConfig = ''
        set -g status-style "bg=#333333 fg=#5eacd3"
        bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded tmux config"
      '';
    };

    # Starship prompt - works in both bash and zsh
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✗](bold red)";
        };
        package.disabled = false;
      };
    };

    # Direnv - directory environment manager
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    
    # FZF - fuzzy finder
    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
  };

  # Common XDG configuration
  xdg = {
    enable = true;
    userDirs.enable = true;
  };

  # Common terminal configuration
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
    LESS = "-R";
  };
  
  # Common system settings
  nixpkgs.config = {
    allowUnfree = true;
  };
}