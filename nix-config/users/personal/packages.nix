# Personal packages configuration

{ config, pkgs, lib, ... }:

{
  # Packages specific to the personal profile
  home.packages = with pkgs; [
   
    # Development tools
    vscode
    git-lfs
    docker-compose
    insomnia # API client
    
    # Programming
    python311
    python311Packages.pip
    python311Packages.virtualenv
    go
    rustup
    
    
    # Media tools
    ffmpeg
    imagemagick
    
    # Communication
    discord
    signal-desktop
    
    # Productivity
    obsidian # Note taking
    libreoffice
    emacs
    
    # Gaming (uncomment if desired)
    steam
    
    # Multimedia
    mpv # Video player
    
  ];

  # Allow unfree packages (many personal applications require this)
  nixpkgs.config.allowUnfree = true;
}