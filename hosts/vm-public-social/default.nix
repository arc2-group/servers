args: {
  imports = [
    ../../modules/services/sharkey/default.nix
    (import ../../modules/disks/data.nix (
      args
      // {
        mountpoint = "/var";
        device = "/dev/sdb";
      }
    ))
  ];
}
