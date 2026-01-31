{ ... }:
{
  # TODO: load all vhosts in the direcotry automatically
  imports = [
    ./etesync.nix
    ./grafana.nix
    ./matrix.nix
    ./media.nix
    ./pve.nix
    ./qminecraft.nix
    ./qrp.nix
    ./sharkey.nix
    ./uptimekuma.nix
    ./vaultwarden.nix

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
