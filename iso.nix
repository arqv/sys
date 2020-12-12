{ pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = ca-references nix-command flakes
    '';
  };
  programs.fish.enable = true;
  users.users.nixos.shell = pkgs.fish;
}
