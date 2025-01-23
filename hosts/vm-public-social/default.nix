args@{ ... };
{
  imports = [
    ../../modules/services/peertube
    ../../modules/services/misskey
    ../../modules/services/lemmy
    (import ../../modules/disks/data.nix (argsm // { mountpoint = "var"; }))
  ];
}
