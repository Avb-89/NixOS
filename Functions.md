********************************************************************************
Варианты установки

  Bios
        boot.loader.grub.enable = true;
        boot.loader.grub.version = 2;
        boot.loader.grub.device = "/dev/sda";

  EFI
       boot.loader.systemd-boot.enable = true;
       boot.loader.efi.canTouchEfiVariables = true;

  Kernel
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
********************************************************************************
## install the software with "nixos-rebuild switch -I nixpkgs=/root/airapkgs/"

********************************************************************************

Бинарный кэш

    nix = {
      binaryCaches = [ https://hydra.aira.life https://cache.nixos.org ];
      binaryCachePublicKeys = [ "hydra.aira.life-1:StgkxSYBh18tccd4KUVmxHQZEUF7ad8m10Iw4jNt5ak="
      "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs=" ];
      };
********************************************************************************

CJDNS установка настройка

  services.cjdns = {
    enable = true;
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
********************************************************************************

  # you can upgrade your system "nixos-rebuild switch --upgrade"

    system.autoUpgrade.enable = true;

********************************************************************************
Установка языка

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };
********************************************************************************

Установка временной зоны

  # Set your time zone.
    time.timeZone = "Europe/Samara";
********************************************************************************
Zabbix

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
********************************************************************************
Firewall

  networking.firewall = {
    enable = false;
    allowPing = true;
    allowedTCPPorts = [ 80 4001 4002 8545 10050 30303 ];
    allowedUDPPorts = [ 30303 ];
********************************************************************************
