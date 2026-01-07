{ config, inputs, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix

    inputs.nixos-hardware.nixosModules.common-cpu-intel # Intel CPUs

    # enable tlp
    inputs.nixos-hardware.nixosModules.common-pc-laptop # Laptops

    inputs.nixos-hardware.nixosModules.common-pc-ssd # SSD storage
  ];
}
