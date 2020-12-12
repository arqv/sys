{ pkgs, ... }:
{
  imports = [
    ./programs
  ];
  news.display = "silent";
  xdg.userDirs = {
    enable = true;
    desktop = "$HOME/usr";
    documents = "$HOME/usr/doc";
    download = "$HOME/usr/dl";
    music = "$HOME/usr/mus";
    pictures = "$HOME/usr/vis";
    videos = "$HOME/usr/vis";
    publicShare = "$HOME/.etc";
    templates = "$HOME/.etc";
  };
}
