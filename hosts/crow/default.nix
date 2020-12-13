{ pkgs, lib, ... }:
with lib;

{
  imports = [
    ../../profiles/graphical
  ];

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-intel" ];
    initrd = {
      availableKernelModules = [
        "ehci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "sr_mod"
        "rtsx_pci_sdmmc"
        "zfs"
      ];
      postDeviceCommands = mkAfter (builtins.concatStringsSep "\n"
        (lists.forEach [ "root" "home" ]
          (volume: "zfs rollback -r tank/ephemeral/${volume}@blank")));
    };
  };
  fileSystems = {
    "/boot" = {
      device = "/dev/sda1";
      fsType = "ext4";
    };
    "/" = {
      device = "tank/ephemeral/root";
      fsType = "zfs";
    };
    "/home" = {
      device = "tank/ephemeral/home";
      fsType = "zfs";
    };
    "/nix" = {
      device = "tank/nix";
      fsType = "zfs";
    };
    "/persist" = {
      device = "tank/persist";
      fsType = "zfs";
      neededForBoot = true;
    };
  };
  swapDevices = [{
    device = "/dev/sda2";
  }];

  networking.networkmanager.enable = true;
  environment.persistence."/persist".directories = [
    "/etc/NetworkManager/system-connections"
    "/var/lib/bluetooth"
  ];

  hardware.enableRedistributableFirmware = true;

  services = {
    blueman.enable = true;
    printing = {
      enable = true;
      drivers = with pkgs; [
        brlaser
        gutenprint
        gutenprintBin
      ];
    };
    xserver = {
      layout = "latam";
      libinput = {
        enable = true;
        tapping = false;
        disableWhileTyping = true;
      };
    };
  };
}
