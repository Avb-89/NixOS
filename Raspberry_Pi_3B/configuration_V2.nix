{ config, pkgs, lib, ... }:

{
#  imports =
#    [ #  the results of the hardware scan.
#      ./hardware-configuration.nix
#    ];

# Variables_installation

    # Bios
       #boot.loader.grub.enable = true;
       #boot.loader.grub.version = 2;
       #boot.loader.grub.device = "/dev/mmcblk0";

    # EFI
      #boot.loader.systemd-boot.enable = true;
      #boot.loader.efi.canTouchEfiVariables = true;

    # Kernel
    boot.loader.grub.enable = false;
    boot.loader.generic-extlinux-compatible.enable = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelParams = ["cma=32M"];

    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-label/NIXOS_BOOT";
        fsType = "vfat";
        };
        "/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
        };
      };


# Programms
    environment.systemPackages = with pkgs;
      [ wget vim htop mc screen git links2 ];


# LAN_Environment
    services.openssh.enable = true;
    services.openssh.permitRootLogin = "yes";

# System_Settings
    networking.hostName = "Droid-01"; # support via wpa_supplicant.
    time.timeZone = "Europe/Samara";

# Version
    system.nixos.stateVersion = "18.09";
# Users
    users.extraUsers.avb = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "wheel"  ];
  };
    users.extraUsers.root.openssh.authorizedKeys.keys =
    [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKWtDy2FB39MvQcMHHIKNyhnaTf73yeFar9dup2KxFjD avb-8@Sitis"  ];
}
