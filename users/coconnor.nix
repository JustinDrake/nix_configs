{ config, pkgs, ... }:
with pkgs.lib; {
  # make sure the required groups exist
  users.extraGroups = [{
    name = "plugdev";
    gid = 10001;
  }];

  users.extraUsers = {
    coconnor = {
      createHome = false;
      uid = 1100;
      group = "users";
      extraGroups = [
        "wheel"
        "vboxusers"
        "libvirtd"
        "jupyter"
        "transmission"
        "plugdev"
        "audio"
        "video"
        "systemd-journal"
        "docker"
      ];
      home = "/home/coconnor";
      shell = pkgs.bashInteractive + "/bin/bash";
      openssh.authorizedKeys.keyFiles = [ ./ssh/coconnor.pub ];
    };
  };
}
