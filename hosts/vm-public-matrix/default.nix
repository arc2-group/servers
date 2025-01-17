args@{ ... }:
{
  imports = [
    ../../modules/services/conduwuit
    (import ../../modules/disks/data.nix (args // { mountpoint = "/var/lib/conduwuit"; }))
  ];
}
