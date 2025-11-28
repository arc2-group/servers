_: {
  services.mautrix-discord = {
    enable = true;
    registerToSynapse = false;
    settings = {
      apply = true;
      homeserver = {
        domain = "blazma.st";
        address = "http://[::1]:6167";
      };
      appservice = {
        id = "discord";
      };
      bridge = {
        permissions = {
          "*" = "relay";
          "blazma.st" = "user";
          "@naides3:blazma.st" = "admin";
          "@spur:blazma.st" = "admin";
        };
        backfill = {
          forward_limits = {
            initial = {
              dm = 100;
              channel = 200;
              thread = 100;
            };
            missed = {
              dm = -1;
              channel = -1;
              thread = -1;
            };
            max_guild_members = -1;
          };
        };
      };
    };

    serviceDependencies = [ "continuwuity.service" ];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];
}
