args: {
  imports = [
    ../../modules/services/navidrome
    ../../modules/services/nixarr
    (import ../../modules/disks/share.nix (args // { mountpoint = "/data"; }))
  ];
}
