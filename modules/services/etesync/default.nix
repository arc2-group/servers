_: {
  disabledModules = [ "services/misc/etebase-server.nix" ];
  imports = [ ./service.nix ];

  services.etebase-server = {
    enable = true;
    settings = {
      global.debug = false;
      allowed_hosts.allowed_host1 = "etesync.blazma.st";
    };
    address = "::";
    openFirewall = true;
  };
}
