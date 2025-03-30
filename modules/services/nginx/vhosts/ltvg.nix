_: {
  services.nginx.virtualHosts = {
    "radio.lrzecickis.id.lv" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "https://ext-ltvg";
        proxyWebsockets = true;
      };
    };
  };

  services.nginx.streamConfig = ''
    server {
      listen 0.0.0.0:8005;
      proxy_timeout 20s;
      proxy_pass ext-ltvg:8005;
    }
    server {
      listen 0.0.0.0:8006;
      proxy_timeout 20s;
      proxy_pass ext-ltvg:8006;
    }
  '';

  networking.firewall = {
    allowedTCPPorts = [
      8005
      8006
    ];
  };
}
