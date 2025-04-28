args: {
  imports = [
    ./modules/gancio.nix
    (import ../../modules/disks/data.nix (
      args
      // {
        mountpoint = "/var";
        device = "/dev/sdb";
      }
    ))
  ];
}
