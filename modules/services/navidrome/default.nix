{
  hostname,
  config,
  inputs,
  ...
}:
let
  secrets = "${hostname}-navidrome-secrets";
in
{
  services.navidrome = {
    enable = true;
    package = inputs.nixpkgs_unstable.navidrome;
    openFirewall = true;
    group = "media";
    settings = {
      MusicFolder = "/media/library/music";
      DataFolder = "/var/navidrome";
      Address = "[::]";
      #PasswordEncryptionKey = "";
      #Prometheus.Enabled = "";
      #Prometheus.MetricsPath = "";
      ScanSchedule = "@every 30m";

      EnableSharing = true;
      Subsonic.ArtistParticipations = true;

      # useful for Japanese
      SearchFullString = true;
      SubsonicArtistParticipations = true;
    };
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
