{
  services.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/data/library/music";
      DataFolder = "/navidrome";

      # someone is against setting this to false
      # EnableStarRating = false;
      # TODO update this someone
      #LastFM.ApiKey = "";
      #LastFM.Secret = "";
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
}
