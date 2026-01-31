_: {
  services.sharkey = {
    enable = true;
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
