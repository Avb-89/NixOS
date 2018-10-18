{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  # BIOS install
    # boot.loader.grub.enable = true;
    # boot.loader.grub.version = 2;
    # boot.loader.grub.device = "nodev"; # or "nodev" for efi only

  # EFI install
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

  # System Settings
    networking.hostName = "panda";
    time.timeZone = "Europe/Samara";

  # Install simple Programms
      environment.systemPackages = with pkgs; [
        wget vim htop mc screen git tree
      ];


  # Install difficult program
      services = {

        # OpenSSH
          openssh = {
            enable = true;
          };

        # Cjdns meh web
          cjdns = {
            enable = true;
            authorizedPasswords = [ "aira-cjdns-node" ];
            ETHInterface.bind = "all";
          };

        # ZabbixAgent
          zabbixAgent = {
            enable = true;
            server = "zbx-01.h.aira.life,zbx-01.corp.aira.life";
           extraConfig =
          ''
             Hostname=panda
             UserParameter=systemd.service[*],${config.systemd.package}/bin/systemctl is-active --quiet '$1' && echo 0 || echo 1
             UserParameter=parity.jsonRPC[*],
          '';
            };
      };
  # ADD Users in system
    users.extraUsers.avb = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = ["wheel"];
      };

  # add keys in ssh (AuthorizedKeys)
      users.extraUsers.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhu3lW+PxR1z3hp6nIXnNJzjtYVEm0tppx4vnBABDVv avb@AIRALAB"


        ];


    system.stateVersion = "17.09";
  }

## install the software with "nixos-rebuild switch -I nixpkgs=/root/airapkgs/"
