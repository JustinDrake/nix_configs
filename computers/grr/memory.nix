{ config, lib, pkgs, ... }:
with lib; {
  config = {
    boot.kernel.sysctl = { "vm.nr_hugepages" = 16484; };
    hardware.mcelog.enable = true;
  };
}
