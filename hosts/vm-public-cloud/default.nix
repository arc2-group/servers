args: {
  imports = [
    ../../modules/services/nextcloud

    (import ../../modules/disks/data.nix (
      args
      // {
        mountpoint = "/data";
        device = "/dev/disk/by-path/pci-0000:01:02.0-scsi-0:0:0:1";
      }
    )) # data

    (import ../../modules/disks/data.nix (
      args
      // {
        mountpoint = "/var";
        device = "/dev/disk/by-path/pci-0000:01:03.0-scsi-0:0:0:2";
      }
    )) # state + program data
  ];
}
