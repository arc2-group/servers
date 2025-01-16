{ pkgs, config, hostname, ... }:
let
  registration-token = "${hostname}-registration-token";
in
{
  conduwuit = {
    enable = true;
    package = pkgs.conduwuit;

    settings.global = {
      server_name = "example.com";
      allow_registration = true;
      trusted_servers = [ "matrix.org" "envs.net" "tchncs.de" "the-apothecary.club" ];
      address = "0.0.0.0";
      max_request_size = 100000000;

      ip_range_denylist = [ "127.0.0.0/8" "10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/16" "100.64.0.0/10" "192.0.0.0/24" "169.254.0.0/16" "192.88.99.0/24" "198.18.0.0/15" "192.0.2.0/24" "198.51.100.0/24" "203.0.113.0/24" "224.0.0.0/4" "::1/128" "fe80::/10" "fc00::/7" "2001:db8::/32" "ff00::/8" "fec0::/10" ];
      log = "debug";
      default_room_version = "11";
      registration_token_file = config.age.secrets.${registration-token}.path;
    };
  };
  age.secrets.${registration-token} = { file = ./registration-token.age; };
}
