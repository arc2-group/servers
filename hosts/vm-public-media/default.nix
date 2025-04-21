args: {
  imports = [
    ../../modules/services/navidrome
    ../../modules/services/nixarr
    ../../modules/services/slskd

    (import ../../modules/disks/data.nix (
      args
      // {
        mountpoint = "/media";
        device = "/dev/disk/by-path/pci-0000:01:02.0-scsi-0:0:0:1";
      }
    )) # media

    (import ../../modules/disks/data.nix (
      args
      // {
        mountpoint = "/var";
        device = "/dev/disk/by-path/pci-0000:01:03.0-scsi-0:0:0:2";
      }
    )) # state + program data
  ];
}
