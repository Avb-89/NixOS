{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  #EFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "atmosensors-02"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
   i18n = {
     consoleFont = "Lat2-Terminus16";
     consoleKeyMap = "us";
     defaultLocale = "en_US.UTF-8";
   };

  # Set your time zone.
   time.timeZone = "Europe/Samara";

  nix.binaryCaches = [ https://cache.nixos.org https://hydra.aira.life ];
  nix.binaryCachePublicKeys = [ "hydra.aira.life-1:StgkxSYBh18tccd4KUVmxHQZEUF7ad8m10Iw4jNt5ak=" ];

   environment.systemPackages = with pkgs; [
     wget vim htop screen git tmux
   ];

  services = {

    # Enable the OpenSSH daemon.
      openssh.enable = true;
    #  vmwareGuest.enable = true;
      zabbixAgent = {
        enable = true;
        server = "airalab.mshome.net";
        extraConfig =
        ''
          Hostname=atmosensors-02.mshome.net
        '';
    };

    # Ethereum network client
    #  parity = {
    #    enable = true;
    #    unlock = true;
    #};
     # IPFS
      #ipfs = {
      #enable = true;
      #pubsubExperiment = true;
      #extraConfig = {
      #   Bootstrap = [
      #      "/dns4/lighthouse.aira.life/tcp/4001/ipfs/QmdfQmbmXt6sqjZyowxPUsmvBsgSGQjm4VXrV7WGy62dv8"
      #      "/dns6/h.lighthouse.aira.life/tcp/4001/ipfs/QmdfQmbmXt6sqjZyowxPUsmvBsgSGQjm4VXrV7WGy62dv8"
      #      "/ip4/52.178.99.60/tcp/4001/ipfs/Qmc4eQzRttAug8vZ2aFqTsUqzUVymvUJZFBiQHL36Vvfri"
      #      "/ip6/fca9:fe44:52fd:5bd4:aa41:44de:750d:bad0/tcp/4001/ipfs/Qmc4eQzRttAug8vZ2aFqTsUqzUVymvUJZFBiQHL36Vvfri"
      #      ];
      #    };
      #  };

     # CJDNS
      cjdns = {
        enable = true;
        authorizedPasswords = [ "aira-cjdns-node" ];
        ETHInterface = {
          bind = "all";
          beacon = 2;
        };
        UDPInterface = {
          bind = "0.0.0.0:42000";
          connectTo = {
            # Akru/Strasbourg
            "164.132.111.49:53741" = {
              password = "cr36pn2tp8u91s672pw2uu61u54ryu8";
              publicKey = "35mdjzlxmsnuhc30ny4rhjyu5r1wdvhb09dctd1q5dcbq6r40qs0.k";
            };
            # Airalab/DigitalOcean
            "188.226.158.11:25829" = {
              password = ";@d.LP2589zUUA24837|PYFzq1X89O";
              publicKey =   "kpu6yf1xsgbfh2lgd7fjv2dlvxx4vk56mmuz30gsmur83b24k9g0.k";
            };
          };
        };
      };
      #Aira-packages
      #  aira-graph ={
      #    enable = true;
      #  };
      };


  networking.firewall = {
    enable = false;
    allowPing = true;
    allowedTCPPorts = [ 80 4001 4002 8545 10050 30303 ];
    allowedUDPPorts = [ 30303 ]; };


  users.extraUsers.root.openssh.authorizedKeys.keys = [
       "AAAAC3NzaC1lZDI1NTE5AAAAIKWtDy2FB39MvQcMHHIKNyhnaTf73yeFar9dup2KxFjD avb-8@Sitis"
    ];

  system.stateVersion = "18.09"; # Did you read the comment?

}
