{ config, pkgs, lib, ... }:
with lib;
let cfg = config.media-presenter;
in {
  imports = [
    ./dependencies/retronix
  ];

  options = {
    media-presenter = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    retronix = {
      enable = true;
      user = "media";
    };

  };
}
