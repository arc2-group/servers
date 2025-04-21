args: {
  imports = [
    ../../modules/services/navidrome
    ../../modules/services/nixarr
    ../../modules/services/slskd
    (import ../../modules/disks/data.nix (args // { mountpoint = "/data"; }))
  ];
}
