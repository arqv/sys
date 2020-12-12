{ pkgs, ... }:
let
  colors = import ../../colors.nix;
in
{
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3GapsSupport = true;
      alsaSupport = true;
      iwSupport = false;
      githubSupport = false;
    };
    config = {
      "bar/top" = {
        inherit (colors.primary) background foreground;
        font-0 = "Agave:pixelsize=11;2.5";
        modules-left = "i3";
        modules-right = "alsa date";
        tray-position = "right";
        tray-maxsize = 16;
        height = 20;
        padding = 1;
        line-size = 2;
        separator = "%{F$#212121}::%{F-}";
        module-margin = 1;
      };
      "bar/bottom" = {
        inherit (colors.primary) background foreground;
        bottom = true;
        font-0 = "Agave:pixelsize=11;2.5";
        modules-right = "battery memory cpu";
        height = 20;
        padding = 1;
        line-size = 1;
        separator = "%{F#212121}::%{F-}";
        module-margin = 1;
      };
      "module/alsa" = {
        type = "internal/alsa";
        label-volume = "%{F${colors.normal.cyan}}Volume:%{F-} %percentage%%";
      };
      "module/i3" = {
        type = "internal/i3";
        label-focused = "%index%";
        label-focused-background = "#212121";
        label-focused-underline = colors.bright.blue;
        label-focused-padding = 2;
        label-unfocused = "%index%";
        label-unfocused-foreground = "#212121";
        label-unfocused-padding = 1;
      };
      "module/battery" = {
        type = "internal/battery";
        battery = "BAT1";
        adapter = "ACAD";
        label-discharging = "%{F${colors.bright.green}}Battery:%{F-} %percentage%%";
        label-charging = "%{F${colors.bright.yellow}}AC:%{F-} %percentage%%";
      };
      "module/cpu" = {
        type = "internal/cpu";
        interval = 2;
        label = "%{F${colors.bright.blue}}CPU:%{F-} %percentage%%";
      };
      "module/memory" = {
        type = "internal/memory";
        interval = 2;
        label = "%{F${colors.bright.magenta}}RAM:%{F-} %percentage_used%%";
      };
      "module/date" = {
        type = "internal/date";
        date = "%H:%M %Y-%m-%d%";
      };
    };
    script = ''
      polybar top &
      polybar bottom &
    '';
  };
}
