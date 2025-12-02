_: {
  services.nginx.virtualHosts = {
    "kviriem.lv" = {
      forceSSL = true;
      enableACME = true;
      serverAliases = [
        "www.kviriem.lv"
      ];

      locations."/" = {
        proxyPass = "http://vm-public-qrp";
        proxyWebsockets = true;
      };
    };
    "pasakumi.kviriem.lv" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        return = "301 https://kviriem.lv$request_uri";
      };
    };
  };
}
