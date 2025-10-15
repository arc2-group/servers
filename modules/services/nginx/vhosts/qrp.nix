_: {
  services.nginx.virtualHosts = {
    "pasakumi.kviriem.lv" = {
      forceSSL = true;
      enableACME = true;
      serverAliases = [
        "kviriem.lv"
        "www.kviriem.lv"
      ];

      locations."/" = {
        proxyPass = "http://vm-public-qrp";
        proxyWebsockets = true;
      };
    };
  };
}
