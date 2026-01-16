{
  mountpoint ? "/data",
  server ? "vm-truenas",
  remotePath,
  ...
}:
{
  fileSystems.${mountpoint} = {
    device = "${server}:${remotePath}";
    fsType = "nfs";
  };
}
