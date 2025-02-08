{ ... }:
{
  services.nginx.virtualHosts =
    let
      base = locations: {
        inherit locations;

        forceSSL = true;
        enableACME = true;
      };
      proxy = { port, verifyCert ? true }: base {
        "/" = {
          proxyPass = "http://vm-public-media:" + toString (port) + "/";
          extraConfig =
            if verifyCert then ''
              if ($ssl_client_verify != SUCCESS) {
                return 403;
              }
            '' else "";
        };
      };
    in
    {
      "media.blazma.st" = proxy { port = 8096; verifyCert = false; }; # Jellyfin

      "transmission.blazma.st" = proxy { port = 9091; };

      "bazarr.blazma.st" = proxy { port = 8686; };
      "lidarr.blazma.st" = proxy { port = 8686; };
      "prowlarr.blazma.st" = proxy { port = 9696; };
      "radarr.blazma.st" = proxy { port = 7878; };
      "readarr.blazma.st" = proxy { port = 8787; };
      "sonarr.blazma.st" = proxy { port = 8989; };
    };
}
