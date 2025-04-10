{ outputs, ... }:
let
  prometheusPort = outputs.nixosConfigurations.vm-monitoring.config.services.prometheus.port;
in
{
  services.nginx.virtualHosts = {
    "prometheus.blazma.st" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://vm-monitoring:${toString prometheusPort}";
      };

      extraConfig = ''
        if ($ssl_client_verify != SUCCESS) {
          return 403;
        }
        if ($permissions !~ "admin") {
          return 403;
        }
      '';
    };
  };
}
