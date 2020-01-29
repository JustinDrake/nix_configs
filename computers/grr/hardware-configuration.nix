{ config, lib, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix> ];

  boot = {
    initrd.availableKernelModules = [
      "ehci_pci"
      "ahci"
      "mpt3sas"
      "xhci_pci"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "sr_mod"
    ];
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_5_4;
    kernelParams = [ "kvm-intel.nested=1" "pcie_aspm=off" "rcutree.rcu_idle_gp_delay=1" ];
    extraModulePackages = [ ];

    loader.grub = {
      # grub bootloader installed to all devices in the boot raid1 array
      devices = [
        "/dev/disk/by-id/ata-ADATA_SP550_2G0420001801"
        "/dev/disk/by-id/ata-ADATA_SP550_2G0420002543"
        "/dev/disk/by-id/ata-ADATA_SP550_2G0420003186"
        "/dev/disk/by-id/ata-ADATA_SP550_2G0420001635"
        "/dev/disk/by-id/ata-ADATA_SP550_2G3220055024"
        "/dev/disk/by-id/ata-ADATA_SP550_2G3220055124"
      ];
      enable = true;
      fontSize = 24;
      # font = "${pkgs.corefonts}/share/fonts/truetype/cour.ttf";
      zfsSupport = true;
      version = 2;
    };
  };

  fileSystems."/" = {
    device = "rpool/root/grr-1";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "rpool/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/bea4ca24-f511-45eb-b979-3d9d7137079e";
    fsType = "ext4";
  };

  nix.maxJobs = 2;
  nix.extraOptions = ''
    build-cores = 5
  '';

  nixpkgs.config = {
    packageOverrides = in_pkgs: {
      linuxPackages = in_pkgs.linuxPackages_5_4;
    };
  };

  security.pam.loginLimits = [{
    domain = "*";
    type = "soft";
    item = "nproc";
    value = "unlimited";
  }];

  hardware.nvidia.nvidiaPersistenced = true;
}
