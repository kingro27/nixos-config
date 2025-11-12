{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  imports = [ 
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = with outputs.overlays; [
    ];
    config.allowUnfree = true;
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
    };
    channel.enable = false;

    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Set Time Zone
  time.timeZone = "Asia/Kathmandu";

  # Set Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Set Grub Config
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = true;

  # Linux Kernel Image
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Host Name
  networking.hostName = "TARDIS";

  # nftables
  networking.nftables.enable = true;

  # DHCP Server config
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;

  # Network Manager Config
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "none";
  networking.networkmanager.wifi.powersave = true;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  # Waydroid Config
  virtualisation.waydroid.enable = true;

  # Container Config (Podman)
  virtualisation.containers.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;
  virtualisation.podman.defaultNetwork.settings.dns_enabled = true;

  # Virtual Machines (libvirtd)
  virtualisation.libvirtd.enable = true;

  # Xserver config
  services.xserver.enable = true;

  # Keyboard Config
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";

  # Flatpak Config
  services.flatpak.enable = true;
  services.flatpak.packages = [ "app.zen_browser.zen" ];

  # Sound Config
  services.pulseaudio.enable = false;
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;

  # GDM Display Manager
  services.displayManager.gdm.enable = true;

  # Enable Printing
  services.printing.enable = true;

  # TLP Config
  services.tlp.enable = true;

  # Bluetooth Enable
  hardware.bluetooth.enable = true;

  # Graphics Enable
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Firefox
  programs.firefox.enable = false;

  # Neovim
  programs.neovim.defaultEditor = false;
  programs.neovim.enable = false;

  # Niri
  programs.niri.enable = true;

  # Localsend
  programs.localsend.enable = true;
  programs.localsend.openFirewall = true;

  # Steam
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "/home/doctor/.steam/root/compatibilitytools.d";
  };

  # Virt-manager
  programs.virt-manager.enable = true;

  # Dconf Config
  programs.dconf.enable = true;

  # XDG config
  xdg.portal.xdgOpenUsePortal = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
  ];

  # User Config
  users.users.doctor.isNormalUser = true;
  users.users.doctor.description = "doctor";
  users.users.doctor.extraGroups = [ "networkmanager" "wheel" "libvirtd" ];

  system.stateVersion = "25.11"; 

}

