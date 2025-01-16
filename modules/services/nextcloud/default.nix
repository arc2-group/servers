{
  pkgs,
  config,
  hostname,
  ...
}:
let
  adminpass = "${hostname}-admin-pass";
in
{
  services.nextcloud = {
    enable = true;
    hostName = "cloud.blazma.st";
    package = pkgs.nextcloud31; # Need to manually increment with every major upgrade.
    home = "/data";
    datadir = "/var/lib/nexctcloud";
    database.createLocally = true;
    configureRedis = true;
    maxUploadSize = "16G";
    autoUpdateApps.enable = true;
    extraAppsEnable = true;
    extraApps = with config.services.nextcloud.package.packages.apps; {
      # List of already packaged apps:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
      inherit
        calendar
        collectives
        contacts
        deck
        end_to_end_encryption
        forms
        groupfolders
        impersonate
        mail
        notes
        onlyoffice
        polls
        tasks
        twofactor_webauthn
        ;
      ## Custom app example
      #socialsharing_telegram = pkgs.fetchNextcloudApp rec {
      #  url =
      #    "https://github.com/nextcloud-releases/socialsharing/releases/download/v3.0.1/socialsharing_telegram-v3.0.1.tar.gz";
      #  license = "agpl3";
      #  sha256 = "sha256-8XyOslMmzxmX2QsVzYzIJKNw6rVWJ7uDhU1jaKJ0Q8k=";
      #};
    };
    settings = {
      overwriteprotocol = "https";
      log_type = "syslog";
      loglevel = 1;
    };
    config = {
      dbtype = "pgsql";
      adminuser = "admin";
      adminpassFile = config.age.secrets.${adminpass}.path;
    };
    phpOptions."opcache.interned_strings_buffer" = "16";
  };

  age.secrets.${adminpass} = {
    file = ./admin-pass.age;
  };
}
