args: {
  imports = [
    ../../modules/services/navidrome
    ../../modules/services/nixarr
    ../../modules/services/slskd
    ../../modules/services/tor-socks

    (import ../../modules/disks/nfs.nix (
      args
      // {
        mountpoint = "/media";
        remotePath = "/mnt/home/arc2/media";
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

  # add coil user to media group
  users.users.coil.extraGroups = [ "media" ];

  # add media.mount as a requirement for media services
  systemd.automounts = [
    {
      requiredBy = [
        "navidrome.service"
        "bazaar.service"
        "lidarr.service"
        "radarr.service"
        "readarr.service"
        "sonarr.service"
        "transmission.service"
        "slskd.service"
      ];
      where = "/media";
    }
  ];

}
