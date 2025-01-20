{ pkgs, config, hostname, inputs, platform, ... }:
{
  services.peertube = {
    enable = true;
    localDomain = "video.blazma.st";
    enableWebHttps = true;
    database = {
      host = ["::"];
      name = "peertube";
      user = "peertube";
      passwordFile = "/etc/peertube/password-rocksdb-db";
    };
    redis = {
      host = ["::"];
      passwordFile = "/etc/peertube/password-redis-db";
    };
    settings = {
      listen.hostname = "0.0.0.0";
    };
  };
};
