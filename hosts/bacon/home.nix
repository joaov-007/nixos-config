{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.zsh.enable = true;

  # Set environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    SHELL = pkgs.zsh;
  };

  # User packages
  home.packages = with pkgs; [
  ];

  services.syncthing.enable = true;

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
