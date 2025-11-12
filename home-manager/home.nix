{
  inputs,
  outptus,
  lib,
  config,
  pkgs,
  ...
}:

let
  homeDir = config.home.homeDirectory;
in

{
  imports = [
  ];

  home.username = "doctor";
  home.homeDirectory = "/home/doctor";

  home.file.".config/fastfetch" = {
    source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/nixos-config/dotfiles/fastfetch";
  };

  home.file.".config/niri" = {
    source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/nixos-config/dotfiles/niri";
  };

  home.file.".config/mako" = {
    source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/nixos-config/dotfiles/mako";
  };

  home.file.".config/containers/systemd" = {
    source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/nixos-config/dotfiles/containers";
  };

  home.file.".local/share/icons" = {
    source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/nixos-config/dotfiles/applications/icons";
  };

  home.packages = with pkgs; [
    alacritty
    brave
    btop
    discord
    fastfetch
    fuzzel
    git
    libnotify
    lua
    mako
    mpv
    nautilus
    qbittorrent
    swayosd
    tree
    unzip
    waybar
    wl-clipboard
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "kingro27";
      email = "96186913+kingro27@users.noreply.github.com";
    };
  };

  dconf.settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
