{
  inputs,
  mountpoint ? "/data",
  device ? "/dev/disk/by-path/pci-0000:01:02.0-scsi-0:0:0:1-part1",
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices = {
    disk = {
      ${device} = {
        type = "disk";
        device = "${device}";
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
