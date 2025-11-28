args: {
  imports = [
    ../../modules/services/minecraft
    (import ../../modules/disks/data.nix (
      args
      // {
        mountpoint = "/srv";
        device = "/dev/sdb";
      }
    ))
  ];
}
