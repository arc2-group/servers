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
      hostname = "kviriem.lv";
      baseurl = "https://kviriem.lv"; # manually set https because enableACME = false
      user_locale = "/opt/gancio/user_locale";
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
