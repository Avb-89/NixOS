{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

# Variables_installation

    # Bios
      # boot.loader.grub.enable = true;
      # boot.loader.grub.version = 2;
      # boot.loader.grub.device = "/dev/sda";

    # EFI
       boot.loader.systemd-boot.enable = true;
       boot.loader.efi.canTouchEfiVariables = true;

# LAN_Environment
  services.openssh.enable = true;

# System_Settings
  networking.hostName = "NixOS"; # support via wpa_supplicant.
  time.timeZone = "Europe/Samara";
  users.extraUsers.avb = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = ["wheel"];
};
  users.extraUsers.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKWtDy2FB39MvQcMHHIKNyhnaTf73yeFar9dup2KxFjD avb-8@Sitis"

# Programms
  environment.systemPackages = with pkgs;
      [wget vim htop mc screen git links2];

# Version
  system.stateVersion = "17.09";
}
