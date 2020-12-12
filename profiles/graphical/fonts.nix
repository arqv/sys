{ pkgs, lib, ... }:
{
  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      corefonts
      agave
      hack-font
    ];
    fontconfig = {
      enable = true;
      subpixel.rgba = "none";
      defaultFonts = with lib; {
        sansSerif = mkForce [ "Noto Sans" ];
        serif = mkForce [ "Noto Serif" ];
        monospace = mkForce [ "Hack" ];
      };
    };
  };
}
