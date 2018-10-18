# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
   boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "atmosensors-01"; # Define your hostname.
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
     wget vim htop screen git tmux #aira.nixpkgs-robonomics_comm-x86_64-linux
   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  services = {

  # Enable the OpenSSH daemon.
    openssh.enable = true;
    vmwareGuest.enable = true;
  #  zabbixAgent = { # Comment by avb
  #    enable = true;
  #    server = "192.168.0.6";
  #    extraConfig =
  #      ''
  #        Hostname=atmosensors-01.corp.aira.life
  #      '';
  #  };

    # Ethereum network client
    parity = {
      enable = true;
      unlock = true;
    };
     # IPFS
    ipfs = {
      enable = true;
      pubsubExperiment = true;
      extraConfig = {
        Bootstrap = [
          "/dns4/lighthouse.aira.life/tcp/4001/ipfs/QmdfQmbmXt6sqjZyowxPUsmvBsgSGQjm4VXrV7WGy62dv8"
          "/dns6/h.lighthouse.aira.life/tcp/4001/ipfs/QmdfQmbmXt6sqjZyowxPUsmvBsgSGQjm4VXrV7WGy62dv8"
          "/ip4/52.178.99.60/tcp/4001/ipfs/Qmc4eQzRttAug8vZ2aFqTsUqzUVymvUJZFBiQHL36Vvfri"
          "/ip6/fca9:fe44:52fd:5bd4:aa41:44de:750d:bad0/tcp/4001/ipfs/Qmc4eQzRttAug8vZ2aFqTsUqzUVymvUJZFBiQHL36Vvfri"
        ];
      };
    };

    # ZabbixAgent - added by avb
      zabbixAgent = {
        enable = true;
        server = "zbx-01.h.aira.life,zbx-01.corp.aira.life";
       extraConfig =
      ''
         Hostname=Atmosenser-01
         UserParameter=systemd.service[*],${config.systemd.package}/bin/systemctl is-active --quiet '$1' && echo 0 || echo 1
         UserParameter=parity.jsonRPC[*],
      '';
    };

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
            publicKey = "kpu6yf1xsgbfh2lgd7fjv2dlvxx4vk56mmuz30gsmur83b24k9g0.k";
          };
        };
      };
    };
    aira-graph ={
      enable = true;
    };
  };
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 3009 10050 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  users.extraUsers.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGU3Zc5wFh2pNC4BRRmE+Jde8qlJ50RN0pvxgz4ilg7T root@citadel"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChd+ARrsZH9uxWqY5mpPqKhkYGkZvww4l+OLB4FZW5Cm82UFBub7TH7RE167RT63od1djCbUIH5sIj9Tgt8RszP1QYSXxweGITn/VVJ8XWo2oduiXrcHQiHH1AFxXeRZg611MRJ5wWObHEnpjv9ae1Eh7/FZzvs/du15A5Jx2p/09BBc8HVeCAZUl28rKfrbQtRJJwDXOBdoA1YlMF0zP95HC1JT9yv2FRtNlK4FStnayw9gMwOU6tU90rHVAMBHgMAYEcCcLvfzByFHd1QgJCa6VzX9B1TMv8txgTUFknGYxUf40IWSNXgmFU3kYMbXQ9LuV0MoJGwISMt22SvHAf spd@aira.life"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDjNHoP86ELLylAizWEvlZqceMXnEup6OZi8JEGng8NJ12d7ofqMzy+yQEPgzzFX1Cr6oTKtzMMLFg5+T0gN/xSbd/Yvu62K8gUoePHajKg/rT78LBjFLpSHZEHjS2vlRenmgMbT1y3qJe99iw+xmJ6P1p9mRlB5xsAC+gCd5kRbw4vO7im3mi6qd6gZZql+fyFRkoVdM0DF0hR4AMAUPM9PGJsSkoMN5PxvCw048f/+0sc5zXMTqy83/eoaYYOu9AtpaXQUqErI8OHJ0DZoai3w0fKXBj9eNt3h0eTBFUXAjjsvRjx0QkOnyBrZKYXk3tEnIThWJy2qmMY4IOZRyO4RhMC/zBmSJKg5ji7CUeOEnDAs4s2INNVybc0r2ms9BXqIiC+TtjiJImJyjQ2KHkRXLsCHVj9ned9NgcVSJrqA34Ywpu4wmyvAANfsa6Ubz29JoMCeTH7h+W77hw3DF59I5Ju6PBSkg0Z4Vh9xMuocVYiRRI4gBDOuf7yQn+kS6h7Kr69fbXijqccy5jkUn/90aAwzmz3FaXasE+n/StC0IrCkksnitiPwfvh3a67GC/2W6H2gqPvIW6t571NI3sYD24FKtae+T/ROLnwDk6GUFuaWN7ZehsYfE7mS5dXwXY+YxP2kmNgWr7r5dkdj5mm7y71mDyKbAd9XwGg7Q5LdQ== akru@aira.life"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/FL9uTGxLKKVeMe1O2PSTzOgu23hRoHe4GA2hNreYo6lwkSO9T6GU2iU4nq9HHBLTN1uBe9ttp61QYiAuddyOWss9zkcu1WU5gMOXmBqFZPj69C/BpOzQZecq1P7AkKIu7esq+fe6ANKMinGJVQhrsrknwYVLznp8OfxIHzq6PLJADI8GZBBGq4hy4AsLbGZqt1jK8aDWoUrwSt+5QdQjMLxaljFNxonacmqoMa391V2vncN+npaQETI2nNxoXeLcPy0Yt0oPJccU9oYQh+fg52jSI3yXR8+fhDQyQLKVHHpYtH88wBSu4/fiwRWRAqRJYZg7AYAluEwNFePWnIH/UP1cUbiteWDKvwAoaaXKvGO5mBNi79G+Y42xv72RdHSIiBpvp4zuUCC5bt87k1QwjHeKGVhNMR2ba2Xz4AoJEw7VnCu8R8K6nif6LEr1kbIgmzM+LefnDggzONF5K7IGoMzjMfTJpdLDO3+MJiBsTW471HXgw2UzZKR2gpcHFkf3GcLsOcIOE9lqoDoFHvwpR8IhnK42qdV+m6VaXoWeSEjZEE99vqVNKyWHDAB4MZxNOrwIYSqnHExoNE8UixUYeL2F3Qv3Onjfg4sjDZVA+r0xjO97qm6IDk9NbWmna8E7vZGEh4GPTdHPwfFZHfJL3p8kFNh7AfZHSy1qrtXttw== a.khssnv@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhu3lW+PxR1z3hp6nIXnNJzjtYVEm0tppx4vnBABDVv avb@AIRALAB" # Airalab Rus sysadmin public key
    ];

  system.nixos.stateVersion = "18.03"; # Did you read the comment?

}
