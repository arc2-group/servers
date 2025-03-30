{ ... }:
{
  # TODO: load all vhosts in the direcotry automatically
  imports = [
    ./grafana.nix
    ./matrix.nix
    ./nixarr.nix
    ./pve.nix

    # external
    ./ltvg.nix
  ];

  services.nginx.virtualHosts."_" = {
    default = true;
    rejectSSL = true;
    extraConfig = ''
      return 444;
    '';
  };
}
