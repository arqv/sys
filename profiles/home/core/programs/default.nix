{ pkgs, ... }:
{
  imports = [
    ./fish
    ./git
    ./tmux
    ./nvim
  ];

  home.packages = with pkgs; [
    neofetch
    # command line utilities
    hexyl
    exa
    fd
    ripgrep
    pandoc
    mosh
    signify
    unzip
    # nix stuff
    nixpkgs-fmt
    niv
    cachix

    (pkgs.callPackage ./cxxmatrix.nix { })
  ];

  programs = {
    htop.enable = true;
    fzf.enable = true;
    jq.enable = true;
    bat.enable = true;
    direnv = {
      enable = true;
      enableNixDirenvIntegration = true;
    };
  };
}
