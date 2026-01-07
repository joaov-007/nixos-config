{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dev.user;

  baseUserGroups = [
    "audio"
    "dialout"
    "input"
    "lp"
    "networkmanager"
    "render"
    "scanner"
    "video"
    "git"
  ];

  adminExtraGroups = [
    "wheel"
  ];
in
{
  options.dev.user.users = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, ... }:
        {
          options = {
            description = lib.mkOption {
              type = lib.types.str;
              default = "";
            };

            admin = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };

            logAccess = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };

            shell = lib.mkOption {
              type = lib.types.enum [
                pkgs.bashInteractive
                pkgs.zsh
                pkgs.fish
              ];
              default = pkgs.bashInteractive;
              description = "Login shell for the user";
            };
          };
        }
      )
    );
    default = { };
  };

  config = {
    assertions = lib.mapAttrsToList (user: userCfg: {
      assertion = !(userCfg.logAccess && !userCfg.admin);
      message = "User '${user}': logAccess requires admin = true";
    }) cfg.users;

    users.users = lib.mapAttrs (user: userCfg: {
      isNormalUser = true;
      description = userCfg.description;
      createHome = true;
      shell = userCfg.shell;

      extraGroups =
        baseUserGroups
        ++ lib.optionals userCfg.admin adminExtraGroups
        ++ lib.optionals userCfg.logAccess [ "systemd-journal" ];
    }) cfg.users;

    home-manager.users = lib.genAttrs (lib.attrNames cfg.users) (user: {
      home.username = user;
      home.homeDirectory = "/home/${user}";
      home.stateVersion = "24.05";
    });

  };
}
