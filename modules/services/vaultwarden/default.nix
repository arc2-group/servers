{ hostname, config, ... }:
let
  vwconfig = "${hostname}-vaultwarden-config";
in
{
  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    environmentFile = config.age.secrets.${vwconfig}.path;
    config = {
      ROCKET_ADDRESS = "::";
      ROCKET_PORT = 8222;
    };
  };

  age.secrets.${vwconfig} = {
    file = ./config.env.age;
    owner = "root";
    group = "root";
    mode = "600";
  };

  networking.firewall = {
    allowedTCPPorts = [
      config.services.vaultwarden.config.ROCKET_PORT
    ];
  };
}
