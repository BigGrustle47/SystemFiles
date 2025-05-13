{
  description = "Nix configuration with personal and work environments";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Additional flakes for personal projects
    devenv = {
      url = "github:cachix/devenv/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Nix flake utilities
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }@inputs:
    let
      # System types to support
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      
      # Helper function to generate outputs for each system
      forEachSupportedSystem = nixpkgs.lib.genAttrs supportedSystems;
      
      # Shared configuration options
      sharedConfig = {
        modules = [ ./modules/common.nix ./modules/fonts.nix ];
      };
    in
    {
      homeConfigurations = {
        # Personal profile
        personal = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${builtins.currentSystem};
          modules = [
            ./users/personal/home.nix
            {
              # Pass inputs to home.nix
              _module.args = {
                inherit inputs;
                personalFlakes = import ./users/personal/flakes/default.nix { inherit inputs; };
              };
            }
          ] ++ sharedConfig.modules;
        };
        
        # Work profile
        work = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${builtins.currentSystem};
          modules = [
            ./users/work/home.nix
            {
              # Pass inputs to home.nix
              _module.args = {
                inherit inputs;
              };
            }
          ] ++ sharedConfig.modules;
        };
      };
      
      # Development shells for easier workflow
      devShells = forEachSupportedSystem (system:
        let 
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nix
              home-manager
              git
            ];
            shellHook = ''
              echo "Nix config development shell"
              echo "Commands:"
              echo " - setup-personal: Switch to personal configuration"
              echo " - setup-work:     Switch to work configuration"
              
              setup-personal() {
                home-manager switch --flake .#personal
              }
              
              setup-work() {
                home-manager switch --flake .#work
              }
            '';
          };
        }
      );
    };
}