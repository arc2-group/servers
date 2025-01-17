{ pkgs, config, hostname, inputs, ... }:
let
  registration-token = "${hostname}-registration-token";
in
{
  # Use conduwuit from unstable
  disabledModules = [ "services/matrix/conduwuit.nix" ];
  imports = [ (inputs.unstable + "/nixos/modules/services/matrix/conduwuit.nix") ];

  services.conduwuit = {
    enable = true;
    package = pkgs.conduwuit;

    settings.global = {
      server_name = "example.com";
      allow_registration = true;
      trusted_servers = [ "matrix.org" "envs.net" "tchncs.de" "the-apothecary.club" ];
      address = [ "::" ];
      max_request_size = 100000000;

      log = "debug";
      default_room_version = "11";
      registration_token_file = config.age.secrets.${registration-token}.path;
    };
  };
  age.secrets.${registration-token} = { file = ./registration-token.age; };
}
