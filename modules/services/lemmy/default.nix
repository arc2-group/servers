{ pkgs, config, hostname, inputs, platform, ... }:
{
  services.lemmy = {
    enable = true;
    settings = {
      hostname = "lemmy.blazma.st";
    };
  }
};
