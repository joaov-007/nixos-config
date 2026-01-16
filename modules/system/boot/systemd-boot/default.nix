{ lib, config, pkgs, ... }:

let
  cfg = config.dev.boot.systemd-boot;
in
{
  options = {
    dev.boot.systemd-boot.enable = lib.mkEnableOption {
      description = "Toggle systemd-boot settings";
      default = false;
    };

    dev.boot.systemd-boot.configurationLimit = lib.mkOption {
      type = lib.types.int;
      default = 12;
      description = "limit for systemd-boot configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.systemd-boot.configurationLimit = cfg.configurationLimit;
    boot.initrd.systemd.enable = true;
  };
}

