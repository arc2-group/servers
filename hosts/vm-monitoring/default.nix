args: {
  imports = [
    ../../modules/services/monitoring
    (import ../../modules/disks/data.nix (args // { mountpoint = "/var"; }))
  ];
}
