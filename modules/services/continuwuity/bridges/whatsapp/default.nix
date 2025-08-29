_: {
  services.mautrix-whatsapp = {
    enable = true;
    registerToSynapse = false;
    settings = {
      apply = true;
      homeserver = {
        domain = "blazma.st";
        address = "http://[::1]:6167";
      };
      appservice = {
        id = "whatsapp";
      };
      bridge = {
        permissions = {
          "*" = "relay";
          "blazma.st" = "user";
          "@naides3:blazma.st" = "admin";
          "@spur:blazma.st" = "admin";
        };
        history_sync = {
          max_initial_conversations = 10;
        };
      };
    };

    serviceDependencies = [ "continuwuity.service" ];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];
}
