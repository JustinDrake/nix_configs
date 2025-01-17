{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ../../hardware/minisforum-UM350.nix
    ../../network/home/host-thrash.nix
    ../../network/home/resource-media-share.nix
    ../../domains/primary
    ./filesystems.nix
    ./audio.nix
    ./video.nix
  ];

  config = {
    media-presenter.enable = true;

    retronix = {
      enable = true;
      nick = "UFO";
    };

    programs.gamemode.enable = true;

    services.foreign-binary-emulation.enable = true;

    virtualisation.podman.enable = true;
  };
}
