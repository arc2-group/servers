{
  pkgs,
  inputs,
  platform,
  ...
}:
{
  services.gancio = {
    enable = true;
    plugins = [
      pkgs.gancioPlugins.telegram-bridge
      inputs.gancio-plugin-discord.packages.${platform}.default
    ];
    settings = {
      hostname = "events.blazma.st";
    };

    nginx = {
      enableACME = false;
      forceSSL = false;
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
    ];
  };
}
