{ outputs, ... }:
let
  port = outputs.nixosConfigurations.vm-public-cloud.config.services.vaultwarden.config.ROCKET_PORT;
  proxyPass = "http://vm-public-cloud:${toString port}";
in
{
  services.nginx.virtualHosts = {
    "vault.blazma.st" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        inherit proxyPass;
      };

      locations."/admin/" = {
        inherit proxyPass;

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
