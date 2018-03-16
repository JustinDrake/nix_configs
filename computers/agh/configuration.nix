{config, pkgs, ...}:
{
  require =
  [
    ./config-at-bootstrap.nix
    ../../editorIsVim.nix
    ../../haskell-dev.nix
    ../../i18n.nix
    ../../java-dev.nix
    ../../jenkins-master.nix
    ../../media-downloader.nix
    ../../media-presenter.nix
    ../../networks/home.nix
    ../../vm-host.nix
    ../../scala-dev.nix
    ../../standard-env.nix
    ../../standard-packages.nix
    ../../standard-nixpath.nix
    ../../standard-services.nix
    ../../tobert-config.nix
    ../../udev.nix
  ];

  boot =
  {
    kernelPackages = pkgs.linuxPackages_4_14;
    # kernelParams = ["nomodeset"];
    kernelParams = ["amdgpu.cik_support=1" "amdgpu.si_support=1"];
  };
  nixpkgs.config =
  {
    packageOverrides = in_pkgs :
    {
      linuxPackages = in_pkgs.linuxPackages_4_14;
      # steam = in_pkgs.steam.override { newStdcpp = true; };
    };
    kodi =
    {
      enableSteamLauncher = true;
      enableAdvancedLauncher = true;
      enableAdvancedEmulatorLauncher = true;
      enableControllers = true;
    };
  };

  environment.systemPackages = [
    pkgs.btrfs-progs
    pkgs.retroarch
    pkgs.kodi-retroarch-advanced-launchers
  ];

  fileSystems =
  [
    { mountPoint = "/mnt/non-admin-home/";
      device = "/dev/disk/by-label/home";
    }
    { mountPoint = "/mnt/storage";
      device = "/dev/disk/by-label/storage";
    }
  ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio =
  {
    enable = true;
    support32Bit = true;
    daemon =
    {
      config =
      {
        default-sample-rate = "48000";
        high-priority = "yes";
        realtime-scheduling = "yes";
        realtime-priority = "9";
        log-level = "debug";
        avoid-resampling = "yes";
        flat-volumes = "yes";
      };
    };
  };

  networking =
  {
    hostName = "agh"; # must be unique
    useDHCP = false;
    interfaces.enp1s0 =
    {
      ipv4.addresses = [ { address = "192.168.1.2"; prefixLength = 24; } ];
    };
    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    firewall =
    {
      allowedTCPPorts = [ 445 5000 27036 27037];
      allowedUDPPorts = [ 27031 27036 ];
    };
  };

  services.openssh =
  {
    extraConfig = ''
      UseDNS no
    '';
    forwardX11 = true;
  };

  services.xserver =
  {
    enable = true;
    autorun = true;
    xrandrHeads =
    [
      {
        output = "HDMI-0";
        monitorConfig = ''
          Option "PreferredMode" "1920x1080"
        '';
      }
      {
        output = "HDMI-1";
        monitorConfig = ''
          Option "PreferredMode" "1920x1080"
        '';
      }
      {
        output = "HDMI-A-0";
        monitorConfig = ''
          Option "PreferredMode" "1920x1080"
        '';
      }
    ];
    videoDrivers = [ "amdgpu" "modesetting" ];
  };

  services.journald.console = "/dev/tty12";

  system.activationScripts.non-admin-home = ''
    [ -L /home/coconnor ] || ln -s /mnt/non-admin-home/coconnor /home/coconnor
    mkdir -p /workspace/coconnor
    chown coconnor:users /workspace/coconnor
    # [ -L /workspace/coconnor] || ln -s /workspace/coconnor /home/coconnor/Development
  '';

  vmhost.type = "libvirtd";

  services.samba =
  {
    enable = true;
    securityType = "auto";
    extraConfig = ''
      create mask = 0664
      directory mask = 0775
      server role = standalone
      guest account = media
      map to guest = bad user
    '';
    shares =
    {
      media =
      {
        path = "/mnt/storage/media";
        comment = "Public media";
        "writeable" = true;
        "guest ok" = true;
        "guest only" = true;
      };
    };
  };

  services.nix-serve =
  {
    enable = true;
    secretKeyFile = "/etc/nix/agh-1.pem";
  };

  nix.extraOptions = ''
    secret-key-files = /etc/nix/agh-1.pem
  '';
}
