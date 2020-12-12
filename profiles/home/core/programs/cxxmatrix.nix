{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "cxxmatrix-git";
  src = pkgs.fetchFromGitHub {
    owner = "akinomyoga";
    repo = "cxxmatrix";
    rev = "93e505c82f06b67d610a14eff1bce9812ab203c5";
    sha256 = "/zLLJ3sbA+m36QK+AmubkF0IP0zzexXugkYraKHBtbc=";
  };

  dontConfigure = true;
  buildPhase = "make";
  installPhase = "make PREFIX=$out install";
}
