{ outputs, ... }:
let
  uptimekumaPort =
    outputs.nixosConfigurations.vm-monitoring.config.services.uptime-kuma.settings.PORT;
in
{
  services.nginx.virtualHosts = {
    "status.blazma.st" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://vm-monitoring:${uptimekumaPort}";
      };
    };
  };
}
