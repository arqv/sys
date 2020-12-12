# sys

configurations for my systems

## usage
### NixOS systems
```sh
$ nix-shell
nix> rebuild os switch host
```
### non-NixOS systems
#### using home-manager
this is not working atm because of the HM module not getting
the packages from the flake.
```sh
$ nix-shell
nix> rebuild home switch user@host
```

