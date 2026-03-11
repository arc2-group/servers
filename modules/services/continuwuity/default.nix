{
  inputs,
  platform,
  ...
}:
{
  imports = [
    ./bridges
  ];

  services.matrix-continuwuity = {
    enable = true;
    package = inputs.continuwuity.packages.${platform}.default;

    settings.global = {
      server_name = "blazma.st";
      allow_registration = true;
      trusted_servers = [
        "matrix.org"
        "envs.net"
        "tchncs.de"
        "the-apothecary.club"
      ];
      address = [ "::" ];
      max_request_size = 100000000;

      log = "debug";
      default_room_version = "11";
      well_known = {
        client = "https://matrix.blazma.st";
        server = "matrix.blazma.st:443";
        support_mxid = "@spur:blazma.st";
        support_email = "admin+matrix@blazma.st";
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 6167 ];
  };
}
