args: {
  imports = [
    ../../modules/services/nextcloud
    (import ../../modules/disks/share.nix args)
  ];
}
