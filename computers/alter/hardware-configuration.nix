# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [  "ata_piix" "ohci_pci" "ehci_pci" "sd_mod" "sr_mod" ];
  boot.kernelModules = [ "virtio" ];

  fileSystems."/" =
    { device = "/dev/sda1";
      fsType = "ext4";
    };

  nix.maxJobs = 8;
  nix.extraOptions = ''
    build-cores = 0
  '';
  virtualisation.virtualbox.guest.enable = true;
}
