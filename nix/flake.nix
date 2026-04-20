{
  description = "KOU050223's nix-darwin + Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }:
  {
    darwinConfigurations."uozumikouhei-mac" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin"; # Apple Silicon (M1/M2/M3)
      modules = [
        ./modules/darwin.nix
        home-manager.darwinModules.home-manager
        {
          nixpkgs.config.allowUnfree = true;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup-before-nix";
          home-manager.users.uozumikouhei = import ./modules/home.nix;
        }
      ];
    };
  };
}
