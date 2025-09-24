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
    package = inputs.continuwuity.packages.${platform}.default-debug;

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
    };

    extraEnvironment = {
      RUST_BACKTRACE = "yes";
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
