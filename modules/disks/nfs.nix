{
  mountpoint ? "/data",
  server ? "vm-truenas",
  remotePath,
  ...
}:
{
  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true; # needed for NFS

  systemd.mounts = [
    {
      type = "nfs";
      mountConfig = {
        Options = "noatime";
      };
      what = "${server}:${remotePath}";
      where = "${mountpoint}";
    }
  ];

  systemd.automounts = [
    {
      wantedBy = [ "multi-user.target" ];
      where = "${mountpoint}";
    }
  ];
}
