{
  inputs = {
 
    # Unstable branch of Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
 
    # Master branch of home-manager
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
    ... }@inputs:
 
  let
    myNeovim = (nvf.lib.neovimConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      modules = [ ./nvf-configuration.nix ];
    }).neovim;

    inherit (self) outputs;

    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
  in
 
  {
    packages-custom = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};
      
    nixosModules = import ./modules/nixos;

    homeManagerModules = import ./modules/home-manager;

    # The NVF package as neovim
    packages."x86_64-linux".default = myNeovim;
 
    # NixOS configuration
    nixosConfigurations.TARDIS = nixpkgs.lib.nixosSystem {
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
          home-manager.users.doctor = import ./home-manager/home.nix;
        }
      ];
    };
  };
}
