# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos" # home manager
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "khassanov.me"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.usePredictableInterfaceNames = false;

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    inetutils mtr sysstat # Linode diganostic Tools
    wget htop vim tmux git zsh nmap
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
    ohMyZsh = {
      enable = true;
      theme = "bira";
      plugins = [ "git" ];
    };
  };
  programs.vim.defaultEditor = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "yes";
  services.longview = {
    enable = true;
    apiKey = "B0D1461E-BF8F-4857-E2B3014DBA9E3300";
  };

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
    # confFile = "/etc/cjdroute.conf";
  };
  
  services.ntp = {
    enable = true;
    servers = [ "0.pool.ntp.org" "1.pool.ntp.org" ];
  };

  # Firewall
  networking.firewall.allowedTCPPorts = [ 22 80 443 4001 ];
  networking.firewall.allowedUDPPorts = [ 53741 420000 ];
  networking.firewall.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };
  users.extraUsers.khassanov = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/khassanov";
    description = "Alisher Khassanov";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  #  openssh.authorizedKeys.keys = import ./keys.nix;
  };

  users.extraUsers.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/FL9uTGxLKKVeMe1O2PSTzOgu23hRoHe4GA2hNreYo6lwkSO9T6GU2iU4nq9HHBLTN1uBe9ttp61QYiAuddyOWss9zkcu1WU5gMOXmBqFZPj69C/BpOzQZecq1P7AkKIu7esq+fe6ANKMinGJVQhrsrknwYVLznp8OfxIHzq6PLJADI8GZBBGq4hy4AsLbGZqt1jK8aDWoUrwSt+5QdQjMLxaljFNxonacmqoMa391V2vncN+npaQETI2nNxoXeLcPy0Yt0oPJccU9oYQh+fg52jSI3yXR8+fhDQyQLKVHHpYtH88wBSu4/fiwRWRAqRJYZg7AYAluEwNFePWnIH/UP1cUbiteWDKvwAoaaXKvGO5mBNi79G+Y42xv72RdHSIiBpvp4zuUCC5bt87k1QwjHeKGVhNMR2ba2Xz4AoJEw7VnCu8R8K6nif6LEr1kbIgmzM+LefnDggzONF5K7IGoMzjMfTJpdLDO3+MJiBsTW471HXgw2UzZKR2gpcHFkf3GcLsOcIOE9lqoDoFHvwpR8IhnK42qdV+m6VaXoWeSEjZEE99vqVNKyWHDAB4MZxNOrwIYSqnHExoNE8UixUYeL2F3Qv3Onjfg4sjDZVA+r0xjO97qm6IDk9NbWmna8E7vZGEh4GPTdHPwfFZHfJL3p8kFNh7AfZHSy1qrtXttw== a.khssnv@gmail.com"
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system = {
    stateVersion = "18.03";
    autoUpgrade.enable = true;
  };
  services.nginx = {
    enable = true;
    recommendedTlsSettings   = true;
    recommendedGzipSettings  = true;
    recommendedOptimisation  = true;
    virtualHosts = {
      "khassanov.me" = {
         forceSSL = true;
         enableACME = true;
         locations = {  };
      };
    };
  };
}
