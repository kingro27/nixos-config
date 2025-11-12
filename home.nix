{ config, pkgs, ... }:

let
  homeDir = config.home.homeDirectory;
in

{
  home.username = "doctor";
  home.homeDirectory = "/home/doctor";

  home.file.".config/fastfetch" = {
    source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/fastfetch";
  };

  home.file.".config/niri" = {
    source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/niri";
  };

  home.file.".config/mako" = {
    source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/mako";
  };

  home.file.".config/containers/systemd" = {
    source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/containers";
  };

  home.file.".local/share/applications" = {
    source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/applications/applications";
    executable = true;
  };

  home.file.".local/share/icons" = {
    source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/applications/icons";
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
    unzip
    waybar
    wl-clipboard
  ];

  programs.git = {
    enable = true;
    userName = "kingro27";
    userEmail = "96186913+kingro27@users.noreply.github.com";
  };

  home.stateVersion = "25.05";
}
