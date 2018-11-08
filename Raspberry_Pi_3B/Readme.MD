$ nix-build \
  -I nixpkgs=https://github.com/ElvishJerricco/nixpkgs/archive/cross-nixos-aarch64-2018-08-05.tar.gz \
  system.nix -A config.system.build.sdImage -o sdImage
$ sudo dd if=sdImage/sd-image/*.img of=/dev/YOUR_SD_CARD status=progress


Download http://nixos-arm.dezgeg.me/installer
  need https://www.cs.helsinki.fi/u/tmtynkky/nixos-arm/installer/sd-image-aarch64-linux.img
