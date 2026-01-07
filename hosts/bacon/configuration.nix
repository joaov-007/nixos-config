{ config
, lib
, pkgs
, ...
}:

{
  #  imports = [
  #    ./hardware-configuration.nix
  #  ];

  # enable systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hide the OS choice for bootloaders.
  # It's still possible to open the bootloader list by pressing any key
  # It will just not appear on screen unless a key is pressed
  boot.loader.timeout = 3;

  boot = {

    plymouth = {
      enable = true;
      theme = "bgrt";
      #  themePackages = with pkgs; [
      #    # By default we would install all themes
      #    (adi1090x-plymouth-themes.override {
      #      selected_themes = [ "" ];
      #    })
      #  ];

    };

    # Enable "Silent boot"
    consoleLogLevel = 3;

    initrd.verbose = false;

    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
  };

  networking.hostName = "bacon"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  networking.firewall = {
    enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [
    "pt_BR.UTF-8/UTF-8"
  ];

  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.gnome.games.enable = false;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany
  ];

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };

  hardware.graphics = {
    # hardware.opengl until NixOS 24.05
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD (for HD Graphics starting Broadwell (2014) and newer)
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i965";
  }; # Force intel-media-driver

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
  };

  hardware.bluetooth.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cpu;
  };

  services.syncthing = {
    enable = false;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.joaov = {
    isNormalUser = true;
    home = "/home/joaov";
    extraGroups = [
      "wheel"
      "input"
      "video"
      "networkmanager"
      "systemd-journal"
    ];
    description = "Joao Victor";
    packages = with pkgs; [
      btop
    ];
    shell = pkgs.zsh;
  };

  # programs.firefox.enable = true;

  programs.zsh.enable = true;

  services.blueman.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    neovim
    wget
    xclip
    librewolf
    nixfmt-rfc-style
    nixfmt-tree
    git
    bitwarden-desktop
    calibre
    wayvnc
    # android-tools
    # scrcpy
    # qtscrcpy
  ];

  security = {
    polkit.enable = true;
    auditd.enable = true;
    rtkit.enable = true;
  };

  nix.package = pkgs.lix;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

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

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.geoclue2 = {
    enable = lib.mkForce false;
  };

  services.fstrim = {
    enable = true;
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
