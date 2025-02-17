{ ... }:
{
  imports = [
    ./matrix.nix
    ./media.nix
  ];

  services.nginx.virtualHosts."_" = {
    default = true;
    rejectSSL = true;
    extraConfig = ''
      return 444;
    '';
  };
}
