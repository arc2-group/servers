_: {
  services.nginx.appendHttpConfig = ''
    upstream pve {
      server vm-public-social:3000;
    }
  '';

  services.nginx.virtualHosts = {
    "social.blazma.st" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://sharkey";
        proxyWebsockets = true;
      };

      extraConfig = ''
        ssl_verify_client off;
        client_max_body_size 1g;
      '';
    };
  };
}
