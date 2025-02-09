_: {
  services.nginx.virtualHosts = {
    "matrix.blazma.st" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://vm-public-matrix:6167";
      };
    };
  };
}
