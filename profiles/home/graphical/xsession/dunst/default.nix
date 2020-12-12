{ pkgs, ... }:
let
  colors = import ../../colors.nix;
in
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "Hack 9";
        markup = "yes";
        format = "<b>%s</b> - <i>%a</i>\\n%b";
        sort = "yes";
        indicate_hidden = "yes";
        alignment = "left";
        word_wrap = "yes";
        ignore_newline = "no";
        geometry = "300x50-8+28";
        transparency = 5;
        padding = 10;
        horizontal_padding = 10;
        frame_width = 2;
        frame_color = "#212121";
      };
      urgency_low = {
        frame_color = colors.normal.blue;
        timeout = 4;
        inherit (colors.primary) background foreground;
      };
      urgency_normal = {
        frame_color = colors.normal.green;
        timeout = 6;
        inherit (colors.primary) background foreground;
      };
      urgency_critical = {
        frame_color = colors.normal.red;
        timeout = 8;
        inherit (colors.primary) background foreground;
      };
    };
  };
}
