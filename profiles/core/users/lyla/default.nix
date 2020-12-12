{ pkgs, ... }:

{
  users.users.lyla = {
    isNormalUser = true;
    description = "Lyla Bravo";
    createHome = true;
    hashedPassword = "$6$Qba86K44LFx$KNFKJwHozJe4KgJADlRJae7VinowqLwcwRXaIXSEDkhSnZh5nekhKjJzcxNHj4znZiUO3OQOQTYR.JPTKqjc7.";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
      "jackaudio"
      "audio"
      "video"
      "input"
      "adbusers"
    ];
  };

  environment.persistence."/persist".directories = [
    "/home/lyla/src"
    "/home/lyla/usr"
    "/home/lyla/etc"
    "/home/lyla/bin"
    "/home/lyla/.mozilla"
    "/home/lyla/.ssh"
  ];
}
