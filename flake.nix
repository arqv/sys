{
  description = "system configuration";
  inputs = {
    pkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hardware.url = "github:NixOS/nixos-hardware";
    home = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "pkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    neovim = {
      url = "github:mjlbach/neovim-nightly-overlay/flakes";
      inputs.nixpkgs.follows = "pkgs";
    };
    emacs.url = "github:nix-community/emacs-overlay";
  };
  outputs = inputs@{ pkgs, hardware, home, ... }:
    let
      defaultSystem = "x86_64-linux";

      pkgsFor = system: import pkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          inputs.neovim.overlay
          inputs.emacs.overlay
        ];
      };

      mkSystem = hostName: { system, inputs, pkgs, extraModules ? [ ] }:
        inputs.pkgs.lib.nixosSystem (
          let
            globalConfig = {
              environment.homeBinInPath = true;
              networking = {
                inherit hostName;
                hostId = pkgs.lib.strings.substring 0 8
                  (builtins.hashString "sha1" hostName);
              };
              nix = {
                registry = {
                  nixpkgs.flake = inputs.pkgs;
                };
                binaryCaches = [
                  "https://nix-community.cachix.org"
                ];
                binaryCachePublicKeys = [
                  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                ];
                nixPath = [
                  "nixpkgs=${inputs.pkgs}"
                  "nixos-config=${inputs.self}/configuration.nix"
                  "home-manager=${inputs.home}"
                  "/nix/var/nix/profiles/per-user/root/channels"
                ];
              };
              nixpkgs.pkgs = pkgs;
              system.stateVersion = "21.03";
              users.mutableUsers = false;
            };
          in
          {
            inherit system;
            modules = [
              globalConfig
              (./hosts + "/${hostName}/default.nix")
              ./profiles/core
              inputs.home.nixosModules.home-manager
            ] ++ extraModules;
          }
        );

      mkHomeModule = username: hostName: extraModules: ({ config, pkgs, ... }: {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username} = { ... }: {
            imports = [
              ./profiles/home/core
              (./profiles/home/hosts + "/${hostName}")
            ] ++ extraModules;
            home = {
              inherit username;
              homeDirectory = "/home/${username}";
              extraOutputsToInstall = [ "doc" "man" ];
              stateVersion = "21.03";
            };
            programs.home-manager.enable = true;
          };
        };
      });

      mkHome = username: hostName: { system, pkgs, extraModules ? [ ], ... }:
        # TODO: Fix package overlays not working on non-NixOS module home-manager
        home.lib.homeManagerConfiguration {
          inherit system username pkgs;
          homeDirectory = "/home/${username}";
          configuration = { ... }: {
            imports = [
              ./profiles/home/core
              (./profiles/home/hosts + "/${hostName}")
            ] ++ extraModules;
            home = {
              inherit username;
              homeDirectory = "/home/${username}";
              extraOutputsToInstall = [ "doc" "man" ];
              stateVersion = "21.03";
            };
            programs.home-manager.enable = true;
          };
        };
    in
    {
      nixosConfigurations = {
        crow = mkSystem "crow" {
          inherit inputs;
          system = defaultSystem;
          pkgs = pkgsFor defaultSystem;
          extraModules = with inputs; [
            impermanence.nixosModules.impermanence
            hardware.nixosModules.lenovo-thinkpad-t420
            hardware.nixosModules.common-pc-laptop-ssd
            (mkHomeModule "lyla" "crow" [
              ./profiles/home/graphical
            ])
          ];
        };
      };

      homeManagerConfigurations = {
        "lyla@crow" = mkHome "lyla" "crow" {
          system = defaultSystem;
          pkgs = pkgsFor defaultSystem;
          extraModules = with inputs; [
            "${impermanence}/home-manager.nix"
          ];
        };
      };

      devShell.${defaultSystem} = import ./shell.nix {
        pkgs = pkgsFor defaultSystem;
      };
    };
}
