args: {
  imports = [
    ../../modules/services/navidrome
    ../../modules/services/nixarr
    (import ../../modules/disks/data.nix (args // { mountpoint = "/data"; }))
  ];
}
