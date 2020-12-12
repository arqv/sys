{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Lyla Bravo";
    userEmail = "arqv@protonmail.com";
    delta.enable = true;
  };
}
