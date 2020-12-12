{ pkgs, ... }:
{
  systemd.services.rebuildHome = {
    requiredBy = [ "multi-user.target" ];
    description = "Rebuild user home directory";
    path = with pkgs; [
      nixFlakes
      sudo
      dbus
    ];
    restartIfChanged = false;
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      #!${pkgs.stdenv.shell}
      users=$(ls /home)
      cd /home/lyla/etc/sys
      for user in $users; do
        sudo -u $user nix-shell --run \
          "rebuild home switch $user@$(cat /etc/hostname)"
      done
    '';
  };
}
