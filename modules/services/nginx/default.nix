{ config, ... }:
{
  services = {
    nginx = {
      enable = true;

      # Use recommended settings
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      # Only allow PFS-enabled ciphers with AES256
      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

      appendHttpConfig = ''
        ssl_client_certificate ${./ssl_client_certificate.crt};
        ssl_verify_client optional;

        map $ssl_client_s_dn $permissions {
          default "";
          "~*CN=suffocate3069" "admin";
          "~*CN=condone4519" "admin";
          "~*CN=uneasy8119" "admin";
          "~*CN=muster4333" "admin";

          "~*CN=LatviaFM" "pve";
        }
      '';

      # Status page for Prometheus Nginx exporter
      statusPage = true;
    };

    # Prometheus metrics for Nginx
    prometheus.exporters.nginx = {
      enable = true;
      port = 9113;
      listenAddress = "[::]";
    };

    # logrotate to delete locally saved logs
    logrotate.enable = true;
    logrotate.settings.nginx = {
      frequency = "daily";
      rotate = 0; # don't keep anything
    };
  };

  # Server certificates
  security.acme = {
    acceptTerms = true;
    defaults.email = "yam-divided-casino@duck.com";
  };

  imports = [
    ./vhosts
  ];

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
      config.services.prometheus.exporters.nginx.port
    ];
    allowedUDPPorts = [ 443 ];
  };
}
