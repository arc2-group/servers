_: {
  services.nginx.appendHttpConfig = ''
    upstream pve {
      server [fd5e:934f:acab:3::ffff]:8006;
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
        ssl_verify_client on;
        if ($ssl_client_verify != SUCCESS) {
          return 403;
        }
        if ($permissions !~ "admin|pve") {
          return 403;
        }

        client_max_body_size 4g;
      '';
    };
  };
}
