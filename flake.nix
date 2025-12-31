{
  description = "Bacon Setup for personal use and fun";

  outputs =
    inputs@{
      self,
    }:
    let
      system = "x86_64-linux";
      lib = inputs.nixpkgs.lib;

      hosts = lib.attrNames (lib.filterAttrs (name: val: val == "directory") (builtins.readDir ./hosts));

      nixpkgs-patched = (import inputs.nixpkgs-nightly { inherit system; }).applyPatches {
        name = "nixpkgs-patched";
        src = inputs.nixpkgs;
        patches = [
          #()
        ];
      };

      pkgs = import nixpkgs-patched {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      pkgs-stable = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

    in
    {
      nixosConfigurations = lib.genAttrs hosts (
        host:
        lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/${host}
            ./modules/system
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit pkgs pkgs-stable inputs; };
            }
          ];
          specialArgs = { inherit pkgs-stable inputs; };
        }
      );
    };

  inputs = {

    nixpkgs-nightly.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
}
