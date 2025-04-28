args: {
  imports = [
    ../../modules/services/continuwuity
    (import ../../modules/disks/data.nix (
      args
      // {
        mountpoint = "/var";
        device = "sdb";
      }
    ))
  ];
}
