_: {
  services.nginx = {
    virtualHosts = {
      "mc.kviriem.lv" = {
        forceSSL = true;
        enableACME = true;

        locations."/" = {
          proxyPass = "http://kviriem.falixsrv.me:20006";
          proxyWebsockets = true;
        };
      };
    };
    streamConfig = ''
      server {
        listen 35585 udp; # Bedrock
        proxy_timeout 20s;
        proxy_pass kviriem.falixsrv.me:20005;
      }
    '';
  };

  networking.firewall = {
    allowedUDPPorts = [
      35585
    ];
  };
}
