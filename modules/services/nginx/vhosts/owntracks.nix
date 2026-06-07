_: {
  services.nginx.virtualHosts = {
    "owntracks.blazma.st" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://vm-public-cloud:8083";
        basicAuthFile = ../htpasswd;
      };

      locations."/mqtt" = {
        proxyPass = "http://vm-public-cloud:1883/";
        proxyWebsockets = true;
      };
    };
  };
}
