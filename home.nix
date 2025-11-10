{ config, pkgs, ... }:

{
  home.username = "test";
  home.homeDirectory = "/home/test";

  home.packages = with pkgs; [
    git
  ];

  home.stateVersion = "25.05";
}
