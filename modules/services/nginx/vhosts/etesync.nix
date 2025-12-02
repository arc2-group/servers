{ outputs, ... }:
let
  inherit (outputs.nixosConfigurations.vm-public-cloud.config.services.etebase-server) port;
in
{
  services.nginx.virtualHosts = {
    "etesync.blazma.st" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://vm-public-cloud:${toString port}";
      };

      extraConfig = ''
        ssl_verify_client optional;
      '';

      locations."/admin/" = {
        proxyPass = "http://vm-public-cloud:${toString port}";

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
  };
}
