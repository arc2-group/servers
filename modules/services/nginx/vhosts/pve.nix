_: {
  services.nginx.appendHttpConfig = ''
    upstream pve {
      server 192.168.12.254:8006 weight=5;
      server 192.168.13.254:8006;
    }
  '';

  services.nginx.virtualHosts = {
    "pve.blazma.st" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "https://pve";
        proxyWebsockets = true;
      };

      extraConfig = ''
        if ($ssl_client_verify != SUCCESS) {
          return 403;
        }
        if ($permissions !~ "admin|pve") {
          return 403;
        }
      '';
    };
  };
}
