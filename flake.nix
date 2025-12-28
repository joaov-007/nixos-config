{
  description = "Bacon Setup for personal use and fun";

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
    }:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      overlay = import ./overlay { inherit inputs; };
    in
    {
      nixosConfigurations.bacon = lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/bacon

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit system;
              inherit inputs;
            };
            home-manager.users.user = import ./hosts/bacon/home.nix;
          }
        ];
      };
    };

  inputs = {

    nixpkgs-nightly.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
}
