# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix> ];

  boot = {
    initrd.availableKernelModules =
      [ "xhci_hcd" "ahci" "ohci_pci" "ehci_pci" "usbhid" "usb_storage" ];
    blacklistedKernelModules = [ "radeon" ];
  };

  fileSystems."/" = {
    device = "/dev/sda2";
    fsType = "ext4";
  };

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  nix.maxJobs = 4;
  nix.extraOptions = ''
    build-cores = 0
  '';
}
