_: {
  services.nginx.virtualHosts = {
    "pasakumi.kviriem.lv" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://vm-public-qrp";
        proxyWebsockets = true;
      };
    };
  };
}
