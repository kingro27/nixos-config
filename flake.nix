{
  description = "NixOS config";

  inputs = {

    # Nixpkgs-unstable repo
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home-Manager Master Branch
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
 
    # v0.8 branch of NVF
    nvf = {
      url = "github:notashelf/nvf/v0.8";
      inputs.nixpkgs.follows = "nixpkgs";
    };
 
    # latest branch of Nix-Flatpaks 
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };
 
  outputs = { 
    self, 
    nixpkgs, 
    home-manager, 
    nvf, 
    nix-flatpak, 
    ... 
  }@inputs:
 
  let
    inherit (self) outputs;

    myNeovim = (nvf.lib.neovimConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      modules = [ ./nvf-configuration.nix ];
    }).neovim;
  in
 
  {
    # The NVF package as neovim
    packages."x86_64-linux".default = myNeovim;

    # Modules for Nix OS
    nixosModules = import ./modules/nixos;

    # Modules for Home Manager
    homeManagerModules = import ./modules/home-manager;
 
    # NixOS configuration
    nixosConfigurations = {
      TARDIS = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; myNeovim = myNeovim; };
        modules = [
          ./nixos/configuration.nix
 
          # NixOS module for Nix Flatpak
          nix-flatpak.nixosModules.nix-flatpak
 
          ({pkgs, ...}: {
            environment.systemPackages = [ myNeovim ];
          })
 
          # Nix OS module for Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.doctor = {imports = [ ./home-manager/home.nix ];};
          }
        ];
      };
    };
  };
}
