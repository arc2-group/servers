args: {
  imports = [
    ../../modules/services/etesync
    ../../modules/services/vaultwarden

    (import ../../modules/disks/data.nix (
      args
      // {
        mountpoint = "/var";
        device = "/dev/disk/by-path/pci-0000:01:03.0-scsi-0:0:0:2";
      }
    )) # state + program data
  ];
}
