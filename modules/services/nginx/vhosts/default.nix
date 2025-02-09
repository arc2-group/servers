{ ... }:
{
  imports = [
    ./nixarr.nix
  ];

  services.nginx.virtualHosts."_" = {
    default = true;
    rejectSSL = true;
  };
}
