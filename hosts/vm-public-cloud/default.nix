args: {
  imports = [
    (import ../../modules/disks/data.nix (
      args
      // {
        mountpoint = "/var";
      }
    ))
  ];
}
