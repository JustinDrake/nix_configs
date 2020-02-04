{ config, pkgs, ... }:
let androidsdk = pkgs.androidsdk_9_0;
in {
  config = {
    environment.shellInit = ''
      export ANDROID_HOME=${androidsdk}
      export JAVA_HOME=${pkgs.jdk}
    '';

    environment.systemPackages = with pkgs; [
      ammonite
      androidsdk
      ansible
      buildah
      git
      jdk
      maven3
      metals
      operator-sdk
      podman
      python3Packages.pip
      qemu
      sbt
      scala
      vagrant
    ];

    nixpkgs.config = {
      android_sdk.accept_license = true;

      cabal.libraryProfiling = true;

      haskellPackageOverrides = self: super: {
        mkDerivation = expr:
          super.mkDerivation (expr // { enableLibraryProfiling = true; });
      };
    };

    virtualisation.docker = {
      enable = true;
      autoPrune.enable = true;
    };
  };
}
