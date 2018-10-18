{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Machine-configuration
  networking.hostName = "waterdrone-01.corp.aira.life";
  time.timeZone = "Europe/Samara";
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";  };
  # Open ports in the firewall.
  networking.firewall = {
    enable = false;
    allowPing = true;
    allowedTCPPorts = [ 30303 10050 ];
    allowedUDPPorts = [ 30303 42000 ];  };
  # Add Usb-Modem
  hardware.usbWwan.enable=true;

  # Add additional packages
  nix.binaryCaches = [ https://cache.nixos.org https://hydra.aira.life ];
  nix.binaryCachePublicKeys = [ "hydra.aira.life-1:StgkxSYBh18tccd4KUVmxHQZEUF7ad8m10Iw4jNt5ak=" ];

  # Install simple Programms
   environment.systemPackages = with pkgs; [
     wget mc vim htop screen git usbutils python3 gcc gnumake busybox  #robonomics_comm
   ];

  # Install configured Programms
  services = {

  # CRON sheduller
    cron = {
    enable = true;
    systemCronJobs = [
      "* * * * *      root    /nix/store/lh78lc9py32d8q384qgdx2da68icdram-usb-modeswitch-2.5.2/bin/usb_modeswitch -v 12d1 -p 1f01 -J > /dev/null 2>&1"
    ];
  };
    udev.extraRules =
      ''
      ATTR{idVendor}=="12d1", ATTR{idProduct}=="1f01", RUN+="/nix/store/lh78lc9py32d8q384qgdx2da68icdram-usb-modeswitch-2.5.2/bin/usb_modeswitch '%b/%k'"

      '';


  # Install OpenSSH daemon. (the keys are below)
    openssh.enable = true;
    openssh.permitRootLogin = "yes";

  # install Zabbix Agent
    zabbixAgent = {
      enable = true;
      server = "192.168.0.6,zbx-01.h.aira.life,zbx-01.corp.aira.life";
      extraConfig =
        ''
          Hostname = waterdrone-01.corp.aira.life
          UserParameter=systemd.service[*],${config.systemd.package}/bin/systemctl is-active --quiet '$1' && echo 0 || echo 1
          UserParameter=parity.jsonRPC[*],
        '';
    };

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
         "/ip4/13.95.236.166/tcp/4001/ipfs/QmdfQmbmXt6sqjZyowxPUsmvBsgSGQjm4VXrV7WGy62dv8"
          "/ip6/fcd5:9d3a:b122:3de1:2742:a3b7:c9c4:46d9/tcp/4001/ipfs/QmdfQmbmXt6sqjZyowxPUsmvBsgSGQjm4VXrV7WGy62dv8"
          "/dns4/lighthouse.aira.life/tcp/4001/ipfs/QmdfQmbmXt6sqjZyowxPUsmvBsgSGQjm4VXrV7WGy62dv8"
          "/dns6/h.lighthouse.aira.life/tcp/4001/ipfs/QmdfQmbmXt6sqjZyowxPUsmvBsgSGQjm4VXrV7WGy62dv8"
          "/ip4/52.178.99.60/tcp/4001/ipfs/Qmc4eQzRttAug8vZ2aFqTsUqzUVymvUJZFBiQHL36Vvfri"
          "/ip6/fca9:fe44:52fd:5bd4:aa41:44de:750d:bad0/tcp/4001/ipfs/Qmc4eQzRttAug8vZ2aFqTsUqzUVymvUJZFBiQHL36Vvfri"
        ];
      };
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
  };

  # Keys for OpenSSH
  users.extraUsers.root.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChd+ARrsZH9uxWqY5mpPqKhkYGkZvww4l+OLB4FZW5Cm82UFBub7TH7RE167RT63od1djCbUIH5sIj9Tgt8RszP1QYSXxweGITn/VVJ8XWo2oduiXrcHQiHH1AFxXeRZg611MRJ5wWObHEnpjv9ae1Eh7/FZzvs/du15A5Jx2p/09BBc8HVeCAZUl28rKfrbQtRJJwDXOBdoA1YlMF0zP95HC1JT9yv2FRtNlK4FStnayw9gMwOU6tU90rHVAMBHgMAYEcCcLvfzByFHd1QgJCa6VzX9B1TMv8txgTUFknGYxUf40IWSNXgmFU3kYMbXQ9LuV0MoJGwISMt22SvHAf spd@aira.life"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDjNHoP86ELLylAizWEvlZqceMXnEup6OZi8JEGng8NJ12d7ofqMzy+yQEPgzzFX1Cr6oTKtzMMLFg5+T0gN/xSbd/Yvu62K8gUoePHajKg/rT78LBjFLpSHZEHjS2vlRenmgMbT1y3qJe99iw+xmJ6P1p9mRlB5xsAC+gCd5kRbw4vO7im3mi6qd6gZZql+fyFRkoVdM0DF0hR4AMAUPM9PGJsSkoMN5PxvCw048f/+0sc5zXMTqy83/eoaYYOu9AtpaXQUqErI8OHJ0DZoai3w0fKXBj9eNt3h0eTBFUXAjjsvRjx0QkOnyBrZKYXk3tEnIThWJy2qmMY4IOZRyO4RhMC/zBmSJKg5ji7CUeOEnDAs4s2INNVybc0r2ms9BXqIiC+TtjiJImJyjQ2KHkRXLsCHVj9ned9NgcVSJrqA34Ywpu4wmyvAANfsa6Ubz29JoMCeTH7h+W77hw3DF59I5Ju6PBSkg0Z4Vh9xMuocVYiRRI4gBDOuf7yQn+kS6h7Kr69fbXijqccy5jkUn/90aAwzmz3FaXasE+n/StC0IrCkksnitiPwfvh3a67GC/2W6H2gqPvIW6t571NI3sYD24FKtae+T/ROLnwDk6GUFuaWN7ZehsYfE7mS5dXwXY+YxP2kmNgWr7r5dkdj5mm7y71mDyKbAd9XwGg7Q5LdQ== akru@aira.life"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGU3Zc5wFh2pNC4BRRmE+Jde8qlJ50RN0pvxgz4ilg7T root@citadel"
      "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA4VUTiu+/jfWoY66vrAEySjx9CDIBBRLKl/RDUW8nQASB445go2c5clZ9Q07a/WFiTwha8HALeQ+O75BLfXUc0Rl9MqyA6xsD/EQOITmSrU6TvN/DDB+wwvcc280RzoIlppk7cEhilQB7NYfRzQDILIAc6UOD/+DcHHrxb1R76bCNdKZsqZkFeec3C4jfcENgdVHkGSCcfI5VLxWlM8NEumIXwK/C1ZdlakFuZcfZkKEtF85p9ktGC6g83g4cY+/D93+XRWKBtkZz9NDKVjdvestboLsIve8w0DCK7NcDie2QKbq77ZKwweafM3557aGHNMC5cGduoR5EhuKX6+ZBMw== rsa-key-20180801"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDX2d/5Dpq7HOq4goKO/Zd8m7JBdfarLAutTd+FRW1/IvYJzL8l0HnNPPWr4b+YTahOMgHXfUBIcpyWAffASh31FP3TJO3g5ZL7PTx0UMB/Yt4DRlQUL0ETzFQpGraGwYyXUTcJdqnM57xopOgxg1SZLO5YSJbhsbkPjX2yJKS2EMP+wqbqrp20BVQR15GoKEUb2J0vooI5xZvJUjV77Q7Hkvll/SP5Nx2Cn/N+zCH3kmbKUZgvhz90D5k2zCR3pXhRGYCiBKER5Wu6WXtbWhb78NhyarGf5EI2fS24xcm5kcNjMb3B2OVzxGuG1xefI94DFxlNC6WfsCJN4dyDuGqJ tuuzdu@tuuzdu-HOME"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC52y1TxK7a3BeFGJZvzlvVkT3CqNWLuz1m0qPEOqKyO+sUMmKS8vZTTjzm9E8rcY1xtsYYumtrnX8qkiEXG/zEiIMI3CmHx00wSkRE2Wn3jY0uXSqTgND9EHW4HBMyohOwAar++FyrEmqcTgXzKomhMksJ8NWRiy/W10Qgue7DGXZnejvvjg1WBy/RIR90WWfqeG7yej/QsnHVIk/HKxgCDh/xpAN8AOWANEXUHO/tqJcCj1Bl+gilEqQHMR3DxOPwUsfxxpxliW9wkl5WeyTL/wHpNPg73tSyK/8WNIiC37GoYh34ggnMshtzjasP5m5mRExh+yDnZYUja/O+TqwwVM5tUUM1B5oVA1N3uxNQ5KChT1QmbBG0hP3DMvGUNeGmP3f6rcsVlhBsZdumAQBePCj7xhCiIFGLO/lJs1dIxUtyVk9sKpmYf62QiC5bIocIQ2Nts6nQa/zaG/bmVqkoIExAZxefEcc71UCdUE5Dty3qE/q1y4EIaPNJLaTXQjacdRre3PZnybFKN4mD76Q19Vy4v7nyJ3EzbEkcSjQGPxZYl+ml4vCd2YG4qaror5WcRw9GUJFUV1iOJQjRNy0m3SQmR4fmt+D+jtYvc7emGseaAqmqly7+Y4DdWXRIpew0TJK2cCCJHaxbNl/skdh+s/kdJt7FN31D3cS7GTaHTw== senserlex@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKWtDy2FB39MvQcMHHIKNyhnaTf73yeFar9dup2KxFjD avb-8@Sitis"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhu3lW+PxR1z3hp6nIXnNJzjtYVEm0tppx4vnBABDVv avb@AIRALAB"
    ];

  system.stateVersion = "18.03"; # Did you read the comment?

}
