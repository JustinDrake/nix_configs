{ config, lib, pkgs, ... }:
with lib; {
  imports = [];

  config = {
    nix = {
      maxJobs = 0;
    };

    boot = {
      kernelParams = [
        "amd_iommu=off"
      ];

      kernelModules = [ "kvm-amd" ];
    };
  };
}
