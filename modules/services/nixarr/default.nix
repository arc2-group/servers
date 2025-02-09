{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixarr.nixosModules.default
  ];

  nixarr = {
    enable = true;
    mediaDir = "/data";
    stateDir = "/nixarr";

    jellyfin.enable = true;

    transmission = {
      enable = true;
      peerPort = 34789;
    };

    bazarr.enable = true;
    lidarr.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    readarr.enable = true;
    sonarr.enable = true;
  };

  services.flaresolverr.enable = true;

  # Sonarr runs dotnet 6...
  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
  ];

  # Jellyfin and Transmission don't listen on IPv6 (WARN: bodge)
  systemd.services.socat-bridge-jellyfin = {
    description = "Socat bridge for IPv4 to IPv6";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.socat}/bin/socat TCP6-LISTEN:18096,fork TCP4:127.0.0.1:8096";
      Restart = "always";
    };
  };
  systemd.services.socat-bridge-transmission = {
    description = "Socat bridge for IPv4 to IPv6";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.socat}/bin/socat TCP6-LISTEN:19091,fork TCP4:127.0.0.1:9091";
      Restart = "always";
    };
  };
  networking.firewall = {
    allowedTCPPorts = [
      18096
      19091
    ];
  };
}
