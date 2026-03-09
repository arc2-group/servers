{ pkgs, ... }:
{
  services.sharkey = {
    enable = true;
    package = pkgs.sharkey.overrideAttrs {
      version = "2025.4.6";
      src = pkgs.fetchFromGitLab {
        domain = "activitypub.software";
        owner = "TransFem-org";
        repo = "Sharkey";
        tag = "2025.4.6";
        hash = "sha256-TtwlveTIjzDYpFR+F5c0If6E1D2E5MI9I2IoDIV0u7E=";
        fetchSubmodules = true;
      };
    };
    openFirewall = true;
    setupRedis = true;
    setupPostgresql = true;
    setupMeilisearch = true;
    settings = {
      url = "https://social.blazma.st/";
      address = "::";
      port = 3000;
    };
  };
}
