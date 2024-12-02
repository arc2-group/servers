{ config, lib, hostname, ... }:
let
  host-key-path = ../../../hosts/${hostname}/ssh_host_ed25519_key.age;
  use-host-key = builtins.pathExists host-key-path;
in
{
  age.secrets."${hostname}-host-key" = lib.mkIf use-host-key { file = host-key-path; };

  age.identityPaths = lib.optional use-host-key config.age.secrets."${hostname}-host-key".path;

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = lib.mkDefault "no";
    };
    hostKeys = lib.mkIf use-host-key [
      {
        path = config.age.secrets."${hostname}-host-key".path;
        type = "ed25519";
      }
    ];
  };
  services.sshguard.enable = true;
}
