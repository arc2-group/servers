_: {
  services.nginx.virtualHosts = {
    "hass.em.id.lv" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "https://em-haos";
        proxyWebsockets = true;
      };

      extraConfig = ''
        if ($ssl_client_verify != SUCCESS) {
          return 403;
        }
        if ($ssl_client_s_dn !~* "CN=suffocate3069") {
          return 403;
        }
      '';
    };
  };
}
