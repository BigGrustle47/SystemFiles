# Font configuration shared between personal and work profiles

{ config, pkgs, lib, ... }:

{
  # Install and configure fonts
  fonts.fontconfig.enable = true;
  
  # Common fonts that should be available in all profiles
  home.packages = with pkgs; [
    # Programming fonts
    fira-code
    fira-code-symbols
    hack-font
    jetbrains-mono
    
    # Serif fonts
    dejavu_fonts
    liberation_ttf
    noto-fonts
    
    # Sans-serif fonts
    noto-fonts-cjk
    noto-fonts-emoji
    
    # Icon fonts
    font-awesome
    material-icons
    material-design-icons
    
    # Monospace fonts
    inconsolata
    nerdfonts
    
    # Custom fonts
    ibm-plex
    inter
    open-sans
    roboto
    source-code-pro
    source-sans-pro
    ubuntu_font_family
  ];

  # Font configuration
  home.file.".config/fontconfig/fonts.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <!-- Default fonts -->
      <alias>
        <family>serif</family>
        <prefer>
          <family>DejaVu Serif</family>
          <family>Noto Serif</family>
        </prefer>
      </alias>
      <alias>
        <family>sans-serif</family>
        <prefer>
          <family>Inter</family>
          <family>Open Sans</family>
          <family>Noto Sans</family>
        </prefer>
      </alias>
      <alias>
        <family>monospace</family>
        <prefer>
          <family>Hack</family>
          <family>JetBrains Mono</family>
          <family>Fira Code</family>
          <family>Noto Sans Mono</family>
        </prefer>
      </alias>
      <alias>
        <family>system-ui</family>
        <prefer>
          <family>Inter</family>
          <family>Open Sans</family>
        </prefer>
      </alias>
      
      <!-- Font rendering settings -->
      <match target="font">
        <edit name="antialias" mode="assign">
          <bool>true</bool>
        </edit>
        <edit name="hinting" mode="assign">
          <bool>true</bool>
        </edit>
        <edit name="hintstyle" mode="assign">
          <const>hintslight</const>
        </edit>
        <edit name="rgba" mode="assign">
          <const>rgb</const>
        </edit>
        <edit name="lcdfilter" mode="assign">
          <const>lcddefault</const>
        </edit>
      </match>
    </fontconfig>
  '';
}