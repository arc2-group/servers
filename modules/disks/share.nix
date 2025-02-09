{
  mountpoint ? "/data",
  share ? "data",
  ...
}:
{
  fileSystems.${mountpoint} = {
    device = "${share}";
    fsType = "9p";
    options = [ "trans=virtio" ];
  };
}
