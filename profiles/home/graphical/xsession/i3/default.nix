{ pkgs, lib, ... }:
with lib;
let
  colors = import ../../colors.nix;
  modifier = "Mod4";
in
{
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      fonts = [ "Agave 9" ];
      bars = [ ];
      gaps.inner = 8;
      menu = "${pkgs.rofi}/bin/rofi -show drun";
      inherit modifier;
      terminal = "alacritty";
      window.border = 2;
      keybindings = mkOptionDefault {
        "${modifier}+Shift+S" = "exec ${pkgs.flameshot}/bin/flameshot gui";
        "${modifier}+Tab" = "exec ${pkgs.rofi}/bin/rofi -show window";
      };
      colors = {
        inherit (colors.primary) background;
        focused = {
          background = colors.bright.blue;
          border = colors.bright.blue;
          childBorder = colors.normal.blue;
          indicator = colors.bright.blue;
          text = colors.primary.background;
        };
        focusedInactive = {
          border = colors.normal.blue;
          background = colors.normal.blue;
          childBorder = colors.bright.black;
          indicator = colors.normal.blue;
          text = colors.primary.background;
        };
        unfocused = {
          border = colors.normal.black;
          background = colors.normal.black;
          childBorder = colors.normal.black;
          indicator = colors.normal.black;
          text = colors.primary.foreground;
        };
        urgent = {
          border = colors.bright.red;
          background = colors.bright.red;
          childBorder = colors.normal.red;
          indicator = colors.bright.red;
          text = colors.primary.background;
        };
      };
      startup =
        let
          wallpaper = builtins.path {
            path = ../wallpaper.jpg;
            name = "wallpaper.jpg";
          };
        in
        [
          {
            command = "${pkgs.feh}/bin/feh --no-fehbg --bg-fill '${wallpaper}'";
            always = false;
            notification = false;
          }
          {
            command = "systemctl --user restart polybar";
            always = true;
            notification = false;
          }
          {
            command = "systemctl --user start pulseaudio && /nix/persist/system/bin/pajackconnect start";
            notification = true;
          }
        ];
    };
  };
}
