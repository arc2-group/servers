{ ... }:
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
    ];
    allowedUDPPorts = [ 443 ];
  };
}
