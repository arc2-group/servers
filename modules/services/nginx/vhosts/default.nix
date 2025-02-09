{ ... }:
{
  imports = [
    ./matrix.nix
    ./nixarr.nix
  ];

  services.nginx.virtualHosts."_" = {
    default = true;
    rejectSSL = true;
    extraConfig = ''
      return 444;
    '';
  };
}
