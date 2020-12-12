{ pkgs, ... }:

{
  imports = [ ./fonts.nix ];

  sound.enable = true;
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
  };

  programs = {
    light.enable = true;
    slock.enable = true;
    dconf.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = true;
        defaultSession = "xsession";
        session = [
          {
            manage = "desktop";
            name = "xsession";
            start = "exec $HOME/.xsession";
          }
        ];
        autoLogin = {
          enable = true;
          user = "lyla";
        };
      };
    };
    picom = {
      enable = true;
      shadow = false;
      menuOpacity = 0.9;
      inactiveOpacity = 0.95;
      backend = "glx";
      experimentalBackends = true;
    };
    redshift.enable = true;
  };
}
