{ pkgs ? import <nixpkgs> { }, ... }:
let
  rebuild = pkgs.writeScriptBin "rebuild" ''
    #!${pkgs.stdenv.shell}
    arg=$1
    if [[ -z $arg ]]; then
      echo "Usage: $(basename $0) os {build|switch|boot|test} host ..."
      echo "       $(basename $0) home {build|switch} host ..."
      exit 1
    fi
    action=$2
    host=$3
    if [[ -z $host ]]; then
      echo "Host argument wasn't specified"
      exit 1
    fi
        
    shift 3
        
    case $arg in
      os)
        case $action in
          build)
            nix build -v ".#nixosConfigurations.$host.config.system.build.toplevel"
            ;;
          *)
            sudo -E nix shell -v ".#nixosConfigurations.$host.config.system.build.toplevel" -c switch-to-configuration $action $@
            ;;
          esac
        ;;
      home)
        case $action in
          build)
            nix build -v ".#homeManagerConfigurations.\"$host\".activationPackage"
          ;;
          switch)
            nix build -v ".#homeManagerConfigurations.\"$host\".activationPackage"
            ./result/activate
            rm result
          ;;
        esac
        ;;
      *)
        echo "Expected 'home' or 'system', got '$arg'"
        exit 1
        ;;
    esac
  '';
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    nixFlakes
    git
    git-crypt
    rebuild
  ];
}
