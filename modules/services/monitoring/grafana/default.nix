{ config, hostname, ... }:
let
  admin-password = "${hostname}-admin-password";
in
{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "::";
        http_port = 3000;
        #domain = "grafana.blazma.st";
      };
      security = {
        admin_email = "admin+grafana@blazma.st";
        admin_user = "Encroach1342";
        admin_password = "$__file{${config.age.secrets.${admin-password}.path}}";
        #cookie_secure = true;
      };
    };
    provision.datasources.settings.datasources = [
      {
        name = "Prometheus";
        type = "prometheus";
        url = "http://[::1]:${toString config.services.prometheus.port}";
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ config.services.grafana.settings.server.http_port ];

  age.secrets.${admin-password} =
    let
      owner = config.systemd.services.grafana.serviceConfig.User;
    in
    {
      file = ./admin-password.age;
      inherit owner;
      inherit (config.users.users.${owner}) group;
    };
}
