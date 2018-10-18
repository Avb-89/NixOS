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
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "nodev"; # or "nodev" for efi only
#EFI install
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless
    networking.hostName = "panda"; # support via wpa_supplicant.

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";
  time.timeZone = "Europe/Samara";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
      wget vim htop mc screen git tree
  ];

  nix = {
    binaryCaches = [ https://hydra.aira.life https://cache.nixos.org ];
    binaryCachePublicKeys = [ "hydra.aira.life-1:StgkxSYBh18tccd4KUVmxHQZEUF7ad8m10Iw4jNt5ak="
    "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs=" ];
    };

  # need download git clone https://github.com/airalab/airapkgs.git
  # and nixos-rebuild switch -I nixpkgs=/root/airapkgs/

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:


  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";
  users.extraUsers.root.openssh.authorizedKeys.keys = [
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGU3Zc5wFh2pNC4BRRmE+Jde8qlJ50RN0pvxgz4ilg7T root@citadel"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhu3lW+PxR1z3hp6nIXnNJzjtYVEm0tppx4vnBABDVv avb@AIRALAB"
  ];
  ## install the software with "nixos-rebuild switch -I nixpkgs=/root/airapkgs/"
	services.aira-graph.enable = true;
  #services.cjdns.enable = true;

  # CJDNS connect to Public web

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
		 #confFile = "/CJDNS/cjdroute.conf";
	};

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

  # To see when the service runs, see "systemctl list-timers".
  # you can upgrade your system "nixos-rebuild switch --upgrade"
  system.autoUpgrade.enable = true;


  	users.extraUsers.avb = {
  		isNormalUser = true;
  		uid = 1000;
  		extraGroups = [
    	  	"wheel"
  	   ];
	};
}
