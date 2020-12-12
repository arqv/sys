{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 4;
          y = 4;
        };
      };
      font = {
        normal = { family = "Hack"; };
        size = 8;
      };
      colors = import ../colors.nix;
    };
  };
}
