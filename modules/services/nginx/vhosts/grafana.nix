{ outputs, ... }:
let
  grafanaPort =
    outputs.nixosConfigurations.vm-monitoring.config.services.grafana.settings.server.http_port;
in
{
  services.nginx.virtualHosts = {
    "grafana.blazma.st" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://vm-monitoring:${toString grafanaPort}";
      };

      extraConfig = ''
        ssl_verify_client on;
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
