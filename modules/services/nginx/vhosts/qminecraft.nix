_: {
  services.nginx = {
    virtualHosts = {
      "mc.kviriem.lv" = {
        forceSSL = true;
        enableACME = true;

        locations."/" = {
          proxyPass = "http://vm-public-qminecraft:8100";
          proxyWebsockets = true;
        };
      };
    };
    streamConfig = ''
      server {
        listen 35585; # Java
        proxy_timeout 20s;
        proxy_pass vm-public-qminecraft:35585;
      }
      server {
        listen 35585 udp; # Bedrock
        proxy_timeout 20s;
        proxy_pass vm-public-qminecraft:35585;
      }
      server {
        listen 24454 udp; # Voice chat
        proxy_timeout 20s;
        proxy_pass vm-public-qminecraft:24454;
      }
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [ 35585 ];
    allowedUDPPorts = [
      35585
      24454
    ];
  };
}
