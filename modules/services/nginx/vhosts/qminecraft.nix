_: {
  services.nginx.virtualHosts = {
    "mc.kviriem.lv" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://vm-public-qminecraft:8100";
        proxyWebsockets = true;
      };
    };
  };
}
