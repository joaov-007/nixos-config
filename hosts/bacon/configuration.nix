{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 12;

  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [
    "pt_BR.UTF-8/UTF-8"
  ];

  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };

  console = {
    useXkbConfig = true; # use xkb.options in tty.
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany
  ];

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  nixpkgs.config.allowUnfree = true;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth.enable = true;
  };

  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gnome.games.enable = false;

    libinput.enable = true;

    ollama = {
      enable = true;
      package = pkgs.ollama-cpu;
    };

    pipewire = {
      enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
    };

    syncthing = {
      enable = true;
      openDefaultPorts = true; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
    };

    geoclue2 = {
      enable = false;
    };

    fstrim = {
      enable = true;
    };
  };

  dev = {
    boot.plymouth.enable = true;
    user.users = {
      joaov = {
        description = "Joao Victor";
        admin = true;
        shell = pkgs.zsh;
      };
    };
  };

  # programs.firefox.enable = true;

  programs.zsh.enable = true;
  programs.nix-index-database.comma.enable = true;

  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    wget
    xclip
    librewolf
    nixfmt-tree
    git
    btop
    bitwarden-desktop
    bitwarden-cli
    jq
    calibre
    rclone
    borgbackup
    pika-backup
    age
    sops
    # android-tools
    # scrcpy
    # qtscrcpy
  ];

  security = {
    polkit.enable = true;
    auditd.enable = true;
    rtkit.enable = true;
  };

  # specialisation.no-apparmor.configuration = {
  #  security.apparmor.enable = lib.mkForce false;
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  system.autoUpgrade.enable = true;
  services.openssh.enable = lib.mkForce false;
}
