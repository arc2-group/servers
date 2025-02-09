args: {
  imports = [
    ../../modules/services/nixarr
    (import ../../modules/disks/share.nix (args // { mountpoint = "/data"; }))
  ];
}
