{ lib, config, ... }:
{
  services.nginx.virtualHosts =
    let
      base = locations: {
        inherit locations;

        forceSSL = true;
        enableACME = true;
      };
      proxy =
        {
          port,
          verifyCert ? true,
        }:
        base {
          "/" = {
            proxyPass = "http://vm-public-media:" + toString port;
            extraConfig = lib.mkIf verifyCert ''
              if ($ssl_client_verify != SUCCESS) {
                return 403;
              }
              if ($permissions !~ "admin") {
                return 403;
              }
            '';
          };
        };
    in
    {
      "media.blazma.st" =
        lib.attrsets.recursiveUpdate
          (proxy {
            port = 18096;
            verifyCert = false;
          })
          {
            locations = {
              "/" = {
                extraConfig = ''
                  proxy_buffering off;
                '';
              };
              "/socket" = {
                inherit (config.services.nginx.virtualHosts."media.blazma.st".locations."/") proxyPass;
                proxyWebsockets = true;
              };
            };
          }; # Navidrome; # Jellyfin

      "music.blazma.st" = proxy {
        port = 4533;
        verifyCert = false;
      }; # Navidrome

      "transmission.blazma.st" = proxy { port = 19091; };
      "slskd.blazma.st" = proxy { port = 15030; };

      "bazarr.blazma.st" = proxy { port = 6767; };
      "lidarr.blazma.st" = proxy { port = 8686; };
      "prowlarr.blazma.st" = proxy { port = 9696; };
      "radarr.blazma.st" = proxy { port = 7878; };
      "readarr.blazma.st" = proxy { port = 8787; };
      "sonarr.blazma.st" = proxy { port = 8989; };
    };
}
