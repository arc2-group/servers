{ inputs
, mountpoint ? "/data"
, device ? "sdb"
, ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices = {
    disk = {
      ${device} = {
        type = "disk";
        device = "/dev/${device}";
        content = {
          type = "gpt";
          partitions = {
            main = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "${mountpoint}";
              };
            };
          };
        };
      };
    };
  };
}
