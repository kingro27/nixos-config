# /etc/nixos/flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, ... }@inputs:
  {

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        modules = [
          disko.nixosModules.disko
          ./configuration.nix
        ];
      };
    };
  };
}
