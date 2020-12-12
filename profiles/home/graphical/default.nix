{ pkgs, ... }:
{
  imports = [
    ./xsession
    ./alacritty
  ];

  home.packages = with pkgs; [
    libreoffice
    transmission-gtk
    soulseekqt
    ripcord
    olive-editor
    krita
  ];

  programs = {
    zathura.enable = true;
    firefox.enable = true;
  };
}
