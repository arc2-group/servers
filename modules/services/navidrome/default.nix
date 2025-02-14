{ hostname, config, ... }:
let
  secrets = "${hostname}-navidrome-secrets";
in
{
  services.navidrome = {
    enable = true;
    openFirewall = true;
    group = "media";
    settings = {
      MusicFolder = "/data/library/music";
      DataFolder = "/navidrome";
      Address = "[::]";

      # someone is against setting this to false
      # EnableStarRating = false;
      # TODO update this someone
      # navidrome devs did not cook with these things
      # https://github.com/navidrome/navidrome/discussions/3463
      #PasswordEncryptionKey = "";
      #Prometheus.Enabled = "";
      #Prometheus.MetricsPath = "";
      ScanSchedule = "@every 30m";
      # useful for Japanese
      SearchFullString = true;
      SubsonicArtistParticipations = true;
      # TODO
      #UILoginBackgroundUrl = "";

    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 4533 ];
  };

  age.secrets.${secrets} = {
    file = ./secrets.env.age;
  };

  # continuation of the lastfm secrets mess
  systemd.services.navidrome.serviceConfig = {
    EnvironmentFile = config.age.secrets.${secrets}.path;
    BindReadOnlyPaths = "/etc/resolv.conf";
  };
}
