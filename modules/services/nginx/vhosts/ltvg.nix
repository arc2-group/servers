_: {
  services.nginx.virtualHosts = {
    "radio.lrzecickis.id.lv" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "https://[fd5e:934f:acab:2::8001]";
        proxyWebsockets = true;
      };
    };
  };
}
