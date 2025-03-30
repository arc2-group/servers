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
