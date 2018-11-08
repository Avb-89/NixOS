{ config, pkgs, lib, ... }:

{
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


# Programms_and_Environment
    nix = {
      binaryCaches = [ https://cache.nixos.org https://hydra.aira.life ];
      binaryCachePublicKeys = [ "hydra.aira.life-1:StgkxSYBh18tccd4KUVmxHQZEUF7ad8m10Iw4jNt5ak=" "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs=" ];
          };

    environment.systemPackages = with pkgs;
      [ wget vim htop mc screen git links2 stack ipfs-migrator ];

    services = {
      aira-graph.enable = true;
      zabbixAgent = {
        enable = true;
        server = "zbx-01.h.aira.life,zbx-01.corp.aira.life";
       extraConfig =
        ''
           Hostname=Droid-01
           UserParameter=systemd.service[*],${config.systemd.package}/bin/systemctl is-active --quiet '$1' && echo 0 || echo 1
           UserParameter=parity.jsonRPC[*],
        ''; };
    ipfs = {
      enable = true;
      pubsubExperiment = true;
      extraConfig = {
        Bootstrap = [
              "/dns4/lighthouse.aira.life/tcp/4001/ipfs/QmdfQmbmXt6sqjZyowxPUsmvBsgSGQjm4VXrV7WGy62dv8"
              "/dns6/h.lighthouse.aira.life/tcp/4001/ipfs/QmdfQmbmXt6sqjZyowxPUsmvBsgSGQjm4VXrV7WGy62dv8"
              "/ip4/52.178.99.60/tcp/4001/ipfs/Qmc4eQzRttAug8vZ2aFqTsUqzUVymvUJZFBiQHL36Vvfri"
              "/ip6/fca9:fe44:52fd:5bd4:aa41:44de:750d:bad0/tcp/4001/ipfs/Qmc4eQzRttAug8vZ2aFqTsUqzUVymvUJZFBiQHL36Vvfri" ]; };
            };
          };

# LAN_Environment
    services.openssh.enable = true;
    services.openssh.permitRootLogin = "yes";
    networking.firewall = {
      enable = false;
      allowPing = true;
      allowedTCPPorts = [ 80 4001 4002 8545 10050 30303 ];
      allowedUDPPorts = [ 30303 ]; };
    services.cjdns = {
        enable = true;
        authorizedPasswords = [ "aira-cjdns-node" ];
        ETHInterface.bind = "all";
        UDPInterface = {
          bind = "0.0.0.0:42000";
          connectTo = {
            "164.132.111.49:53741" = {
              password = "cr36pn2tp8u91s672pw2uu61u54ryu8";
              publicKey = "35mdjzlxmsnuhc30ny4rhjyu5r1wdvhb09dctd1q5dcbq6r40qs0.k"; };
            "188.226.158.11:25829" = {
              password = ";@d.LP2589zUUA24837|PYFzq1X89O";
              publicKey = "kpu6yf1xsgbfh2lgd7fjv2dlvxx4vk56mmuz30gsmur83b24k9g0.k"; };
              }; }; };

# System_Settings
    networking.hostName = "Droid-01"; # support via wpa_supplicant.
    time.timeZone = "Europe/Samara";

# Version
    system.stateVersion = "19.03";
# Users
    users.extraUsers.avb = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "wheel"  ];
  };
    users.extraUsers.root.openssh.authorizedKeys.keys =
    [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKWtDy2FB39MvQcMHHIKNyhnaTf73yeFar9dup2KxFjD avb-8@Sitis"  ];
}
