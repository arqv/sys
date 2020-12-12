{ pkgs, ... }:
{
  imports = [
    ./users/lyla

    # ./users/rebuild.nix # only needed when home-manager is not managed by NixOS
    ./locale.nix
  ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = ca-references nix-command flakes
    '';
    trustedUsers = [ "root" "@wheel" ];
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  programs.fish.enable = true;

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
}
