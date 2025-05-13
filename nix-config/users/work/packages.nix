# Work packages configuration

{ config, pkgs, lib, ... }:

{
  # Packages specific to the work profile
  home.packages = with pkgs; [
    # Development tools
    vscode
    git-lfs
    docker-compose
    postman # API client
    
    # Programming languages and tools - tailored for work needs
    nodejs_18 # Specific version for work
    yarn
    python311
    python311Packages.pip
    python311Packages.virtualenv
    
    # Cloud and infrastructure tools
    awscli2
    google-cloud-sdk
    terraform
    kubectl
    kubernetes-helm
    k9s
    
    # Database tools
    dbeaver
    postgresql_15
    
    # Communication
    slack
    zoom-us
    microsoft-edge # For Microsoft Teams web
    
    # Productivity
    libreoffice
    vscode-extensions.ms-vsliveshare.vsliveshare # For pair programming
    
    # Company VPN - example, replace with actual package
    openvpn
    networkmanager-openvpn
    
    # CI/CD tools
    jenkins-cli
    
    # Documentation
    obsidian # For personal notes within work context
    
    # Project management
    jira-cli
    
    # Security tools
    vault # HashiCorp Vault CLI
    sops # Secrets management
    
    # Monitoring & logging
    grafana-loki
    prometheus
    
    # Network tools
    wireshark
    nmap
    tcpdump
    netcat
    
    # Text processing
    pandoc
    pdfgrep
    
    # Editor plugins specific to work
    vscode-extensions.ms-kubernetes-tools.vscode-kubernetes-tools
    vscode-extensions.hashicorp.terraform
    vscode-extensions.redhat.vscode-yaml
    
    # Useful utilities
    gnumake
    yq # YAML processor
    jq # JSON processor
    curl
    wget
    
    # Company-specific tools (examples - replace with actual packages)
    # internal-company-tool-from-overlay
  ];

  # Allow unfree packages (often needed for work software)
  nixpkgs.config.allowUnfree = true;
  
  # Work-specific configuration
  home.file.".npmrc".text = ''
    registry=https://registry.npmjs.org/
    @company:registry=https://npm.company.com/
  '';
  
  # Docker configuration for work
  home.file.".docker/config.json".text = ''
    {
      "auths": {
        "registry.company.com": {}
      },
      "credHelpers": {
        "registry.company.com": "ecr-login"
      }
    }
  '';
}