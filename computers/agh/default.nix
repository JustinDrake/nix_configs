{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ../../hardware/AMD-A10-APU.nix
    ../../hardware/Gigabyte-F2A88XM-D3H.nix
    ../../network/home/host-agh.nix
    ../../network/home/resource-build-cache.nix
    ../../network/home/resource-dns-server.nix
    ../../network/home/resource-media-server.nix
    ../../domains/primary
    ./filesystems.nix
    ./audio.nix
    ./gpu.nix
  ];

  config = {
    developer-base.enable = true;

    virt-host.enable = true;

    services.dnsmasq.enable = true;
    services.fail2ban.enable = true;
    services.foreign-binary-emulation.enable = true;
    services.hw-rand.enable = true;
    services.kbfs.enable = false;
    services.samba.enable = true;
    services.xserver.enable = false;
    services.qa-house-manager.enable = true;
  };
}
