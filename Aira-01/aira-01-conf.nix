# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.kernelParams = [ "panic=1" "boot.panic_on_fail" ];

  # Generate a GRUB menu.
  boot.loader = {
    grub.device = "/dev/sda";
    grub.version = 2;
    timeout = 0;
  };

  boot.initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_blk" "9p" "9pnet_virtio" "virtio-scsi" ];
  boot.initrd.kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" "virtio_scsi" "sym53c8xx" "scsi_mod" "sd_mod" "sg" ];
  boot.kernelModules = [ "kvm_intel" ];

  time.timeZone = "Europe/Samara";
  environment.interactiveShellInit = ''
    export PATH="$PATH:$HOME/bin"
    PS1='\[\033[1;31m\][\A][\h][\u][\w]\$\[\033[0m\] '
  '';
  zramSwap.enable = true;
  networking.firewall = {
    enable = false;
    allowPing = true;
    allowedTCPPorts = [ 80 4001 4002 8545 10050 30303 ];
    allowedUDPPorts = [ 30303 ];
  };

  fileSystems."/".label = "nixos";

  nix = {
    binaryCaches = [ https://hydra.aira.life https://cache.nixos.org ];
    binaryCachePublicKeys = [ "hydra.aira.life-1:StgkxSYBh18tccd4KUVmxHQZEUF7ad8m10Iw4jNt5ak="
    "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs=" ];
  };
  environment.systemPackages = with pkgs; [
    screen
    tmux
    htop
    vim
    nano
    stack
    git
    ipfs-migrator
    robonomics_comm
  ];

  services = {
    vmwareGuest =
      { enable = true;
      };

    openssh = {
      enable = true;
      passwordAuthentication = false;
    };

    zabbixAgent =
      { enable = true;
      server = "zbx-01.h.aira.life,zbx-01.corp.aira.life";
     extraConfig =
    ''
       Hostname=aira-01
       UserParameter=systemd.service[*],${config.systemd.package}/bin/systemctl is-active --quiet '$1' && echo 0 || echo 1
       UserParameter=parity.jsonRPC[*],
    '';
      };

    dnsmasq = {
      enable = true;
      servers = [ "192.168.88.254" ];
    };

    ntp.enable = true;

    cjdns = {
      enable = true;
      authorizedPasswords = [ "aira-cjdns-node" ];
      ETHInterface.bind = "all";
    };

    ipfs = {
      enable = true;
      pubsubExperiment = true;
      extraConfig = {
        Bootstrap = [
          "/dns4/lighthouse.aira.life/tcp/4001/ipfs/QmdfQmbmXt6sqjZyowxPUsmvBsgSGQjm4VXrV7WGy62dv8"
          "/dns6/h.lighthouse.aira.life/tcp/4001/ipfs/QmdfQmbmXt6sqjZyowxPUsmvBsgSGQjm4VXrV7WGy62dv8"
        ];
      };
    };

    parity = {
      enable = true;
      unlock = true;
      package = pkgs.parity-beta;
    };

    aira-graph.enable = true;
  };

  networking.hostName = "aira-01";

  users.extraUsers.root.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChd+ARrsZH9uxWqY5mpPqKhkYGkZvww4l+OLB4FZW5Cm82UFBub7TH7RE167RT63od1djCbUIH5sIj9Tgt8RszP1QYSXxweGITn/VVJ8XWo2oduiXrcHQiHH1AFxXeRZg611MRJ5wWObHEnpjv9ae1Eh7/FZzv$
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDjNHoP86ELLylAizWEvlZqceMXnEup6OZi8JEGng8NJ12d7ofqMzy+yQEPgzzFX1Cr6oTKtzMMLFg5+T0gN/xSbd/Yvu62K8gUoePHajKg/rT78LBjFLpSHZEHjS2vlRenmgMbT1y3qJe99iw+xmJ6P1p9mRlB$
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYPJ8+6GOp7r1wxmGkikKkgEPZw6utpVuJutdKak/czL6Lzw0L+oiuLgyNA4C+WPiZT365Jfgo5N36G3kbEoPi8m9ctchiklovhSfmX4H+dxtYJKC6BJBGrpRY7O1zWQJE+D9mYgwSG9MVN8C/xdjqjM7c13sl$
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/FL9uTGxLKKVeMe1O2PSTzOgu23hRoHe4GA2hNreYo6lwkSO9T6GU2iU4nq9HHBLTN1uBe9ttp61QYiAuddyOWss9zkcu1WU5gMOXmBqFZPj69C/BpOzQZecq1P7AkKIu7esq+fe6ANKMinGJVQhrsrknwYVL$
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGU3Zc5wFh2pNC4BRRmE+Jde8qlJ50RN0pvxgz4ilg7T root@citadel"

    ];
  system.stateVersion = "18.03"; # Did you read the comment?

}
