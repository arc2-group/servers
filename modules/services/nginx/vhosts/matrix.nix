_: {
  services.nginx.virtualHosts = {
    "matrix.blazma.st" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://vm-public-matrix:6167";

        extraConfig = ''
          # increase buffer size and timeouts to allow for longer & larger syncs
          proxy_buffers 128 64k; # 8M
          proxy_read_timeout 15m;
          proxy_send_timeout 15m;
          keepalive_timeout 15m;

          # match max upload size with continuwuity settings
          client_max_body_size 100M;
        '';
      };
    };

    "blazma.st" = {
      forceSSL = true;
      enableACME = true;

      locations."/.well-known/matrix/" = {
        proxyPass = "http://vm-public-matrix:6167";
      };
    };
  };
}
