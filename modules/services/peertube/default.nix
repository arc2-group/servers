{ config, hostname, ... }:
let
  secrets = "${hostname}-peertube-secrets";
  dbPassword = "${hostname}-peertube-db-password";
  redisPassword = "${hostname}-peertube-redis-password";
in
{
  services.peertube = {
    enable = true;
    localDomain = "video.blazma.st";
    enableWebHttps = true;
    listenWeb = 443;
    database = {
      createLocally = true;
      passwordFile = config.age.secrets.${dbPassword}.path;
    };
    redis = {
      createLocally = true;
      passwordFile = config.age.secrets.${redisPassword}.path;
    };
    settings = {
      listen.hostname = "::";
    };
    secrets.secretsFile = config.age.secrets.${secrets}.path;
  };

  age.secrets = {
    ${secrets} = {
      file = ./secrets.age;
      inherit (config.services.peertube) group;
    };
    ${dbPassword} = {
      file = ./db-password.age;
      inherit (config.services.peertube) group;
    };
    ${redisPassword} = {
      file = ./redis-password.age;
      inherit (config.services.peertube) group;
    };
  };
}
