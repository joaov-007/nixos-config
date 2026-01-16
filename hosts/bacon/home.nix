{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.zsh.enable = true;
  programs.zsh.dotDir = "${config.xdg.configHome}/zsh";

  xdg.enable = true;
  xdg.userDirs.createDirectories = true;

  # Set environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    SHELL = pkgs.zsh;
  };

  # User packages
  home.packages = with pkgs; [
    btop
  ];

  services.ssh-agent = {
    enable = true;
    enableZshIntegration = true;
  };

  services.syncthing.enable = true;

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
