# /etc/nixos/flake.nix
{
  description = "New NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf.url = "github:notashelf/nvf";

  };

  outputs = inputs@{ self, nixpkgs, home-manager, nvf, ... }: {

    packages."x86_64-linux".default =
      (nvf.lib.neovimConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
	modules = [ ./nvf-configuration.nix ];
      }).neovim;

    nixosConfigurations = {
      TARDIS = nixpkgs.lib.nixosSystem {
        modules = [
	  ./configuration.nix

	  ({pkgs, ...}: {
	    environment.systemPackages = [ self.packages.${pkgs.stdenv.system}.nvim ];
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
