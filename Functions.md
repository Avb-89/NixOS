********************************************************************************
  Variables_installation

      Bios
        boot.loader.grub.enable = true;
        boot.loader.grub.version = 2;
        boot.loader.grub.device = "/dev/mmcblk0";

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
