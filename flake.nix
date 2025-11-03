# /etc/nixos/flake.nix
{
  description = "New NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf.url = "github:notashelf/nvf/v0.8";

    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

  };

  outputs = inputs@{ self, nixpkgs, home-manager, nvf, mango, spicetify-nix, ... }:

  let
    myNeovim = (nvf.lib.neovimConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      modules = [ ./nvf-configuration.nix ];
    }).neovim;
  in

  {

    packages."x86_64-linux".default = myNeovim;

    nixosConfigurations = {
      TARDIS = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; myNeovim = myNeovim; };
        modules = [
          ./configuration.nix

          spicetify-nix.nixosModules.default

          mango.nixosModules.mango
          {
            programs.mango.enable = true;
          }

          ({pkgs, ...}: {
            environment.systemPackages = [ myNeovim ];
          })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.doctor = import ./home.nix;
          }
        ];
      };
    };
  };
}
