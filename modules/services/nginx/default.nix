{ config, ... }:
{
  services.nginx = {
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
    '';

    # Status page for Prometheus Nginx exporter
    statusPage = true;
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

  # Prometheus metrics for Nginx
  services.prometheus.exporters.nginx = {
    enable = true;
    port = 9113;
    listenAddress = "[::]";
  };
}
