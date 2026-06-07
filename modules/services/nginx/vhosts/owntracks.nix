_: {
  services.nginx.virtualHosts = {
    "owntracks.blazma.st" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://vm-public-cloud:8083";
      };
    };
  };
}
