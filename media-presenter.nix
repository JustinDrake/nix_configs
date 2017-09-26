{config, pkgs, ...}:
{
  require =
  [
    ./users/media.nix
    ./musnix
  ];

  musnix =
  {
    enable = true;
    kernel =
    {
      latencytop = true;
      optimize = true;
      realtime = true;
      # must match computer linuxPackages version
      packages = pkgs.linuxPackages_4_9_rt;
    };
  };

  networking.firewall =
  {
    allowedTCPPorts = [ 8180 9090 ];
    allowedUDPPorts = [ 9777 ];
  };

  services.xserver.displayManager.slim =
  {
    enable = true;
    defaultUser = "media";
    autoLogin = true;
  };

  services.xserver.desktopManager.kodi.enable = true;
  services.xserver.desktopManager.default = "kodi";
  services.xserver.windowManager.pekwm.enable = true;
  services.xserver.windowManager.default = "pekwm";
}
