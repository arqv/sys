let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) lib;
  files = lib.filesystem.listFilesRecursive ./.;
in 
  lib.strings.concatStringsSep " " (lib.lists.remove null (lib.lists.flatten (lib.lists.forEach files (a: lib.strings.match ".*/users/(.*)/default.nix" (builtins.toString a)))))

