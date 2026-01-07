{
  description = "Bacon Setup for personal use and fun";

  outputs =
    inputs@{ self
    , ...
    }:
    let
      inherit (self) outputs;

      system = "x86_64-linux";

      lib = inputs.nixpkgs.lib;

      hosts = lib.attrNames (lib.filterAttrs (name: val: val == "directory") (builtins.readDir ./hosts));

      overlays = [
      ];

      nixpkgs-patched = (import inputs.nixpkgs { inherit system; }).applyPatches {
        name = "nixpkgs-patched";
        src = inputs.nixpkgs;
        patches = [ ];
      };

      pkgs = import nixpkgs-patched {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
        overlays = overlays;
      };

      pkgs-stable = import inputs.nixpkgs-stable {
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
          inherit system;
          modules = [
            ./hosts/${host}
            ./modules/system
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit pkgs;
                inherit pkgs-stable;
                inherit inputs;
              };
            }
          ];
          specialArgs = {
            inherit pkgs-stable;
            inherit inputs;
          };
        }
      );

      formatter.${system} = pkgs.nixpkgs-fmt;

    };

  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  };
}
