args: {
  imports = [
    ../../modules/services/lemmy
    ../../modules/services/misskey
    ../../modules/services/peertube
    (import ../../modules/disks/data.nix (args // { mountpoint = "/var"; }))
  ];
}
