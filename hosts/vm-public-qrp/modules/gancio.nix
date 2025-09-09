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
      hostname = "pasakumi.kviriem.lv";
      baseurl = "https://pasakumi.kviriem.lv"; # manually set https because enableACME = false
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
