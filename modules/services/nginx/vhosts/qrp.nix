_: {
  services.nginx.virtualHosts = {
    "events.blazma.st" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://vm-public-qrp";
        proxyWebsockets = true;
      };
    };
  };
}
