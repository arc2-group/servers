_: {
  imports = [
    ./service.nix
  ];

  services.mautrix-gmessages = {
    enable = true;
    registerToSynapse = false;
    settings = {
      apply = true;
      homeserver = {
        domain = "blazma.st";
        address = "http://[::1]:6167";
      };
      appservice = {
        id = "gmessages";
      };
      bridge = {
        permissions = {
          "*" = "relay";
          "blazma.st" = "user";
          "@naides3:blazma.st" = "admin";
          "@spur:blazma.st" = "admin";
        };
      };
      backfill = {
        enabled = true;
      };

    };

    serviceDependencies = [ "continuwuity.service" ];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];
}
