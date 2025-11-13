{
  config,
  hostname,
  inputs,
  platform,
  ...
}:
let
  registration-token = "${hostname}-registration-token";
in
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
      registration_token_file = config.age.secrets.${registration-token}.path;
      well_known = {
        client = "https://matrix.blazma.st";
        server = "matrix.blazma.st:443";
        support_mxid = "@spur:blazma.st";
        support_email = "admin+matrix@blazma.st";
      };
    };
  };

  age.secrets.${registration-token} = {
    file = ./registration-token.age;
    owner = config.services.matrix-continuwuity.user;
    inherit (config.services.matrix-continuwuity) group;
  };

  networking.firewall = {
    allowedTCPPorts = [ 6167 ];
  };
}
