{ config, pkgs, ... }:

{
  imports = [
    ./i3
    ./polybar
    ./dunst
  ];

  services = {
    flameshot.enable = true;
  };

  programs = {
    feh.enable = true;
    rofi = {
      enable = true;
      theme = "sidebar";
      font = "Hack 9";
    };
  };

  xdg.configFile."flameshot/flameshot.ini".text = ''
    [General]
    disabledTrayIcon=true
    drawColor=#ff0000
    drawThickness=0
    saveAfterCopyPath=${config.home.homeDirectory}/usr/vis
    showDesktopNotification=false
  '';

  xsession = {
    enable = true;
    pointerCursor = {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
      size = 16;
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adementary-dark";
      package = pkgs.adementary-theme;
    };
    iconTheme = {
      name = "Elementary-xfce-darker";
      package = pkgs.elementary-xfce-icon-theme;
    };
    font = {
      name = "Noto Sans";
      package = null;
    };
  };
}
