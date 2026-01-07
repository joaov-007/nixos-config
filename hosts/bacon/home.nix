{ config
, pkgs
, lib
, ...
}:

{
  # The username and home directory (must match system user)
  home.username = "joaov";
  home.homeDirectory = "/home/joaov";

  programs.zsh.enable = true;

  # Set environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    SHELL = pkgs.zsh;
  };

  # User packages
  home.packages = with pkgs; [
  ];

  programs.ssh.enable = lib.mkForce false;
  home.stateVersion = "25.05";
}
