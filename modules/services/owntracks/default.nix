{ pkgs, ... }:
{
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        address = "::";
        port = 1883;
        users.owntracks = {
          acl = [
            "readwrite owntracks/#"
          ];
          hashedPassword = "$7$101$wA6bXi8eoATw6NX6$3wzLTzKRs4bScmwL9sVhkeIXUKR5gQX5K+ZR0P9j5n5N6oHBpVAvtMg+A3CrT6Wc5v3GRnvT9XfC0tYdt2Ruyw==";
        };
        settings = {
          protocol = "websockets";
        };
      }
      {
        address = "::1";
        port = 1884;
        acl = [ "pattern readwrite owntracks/#" ];
        settings.allow_anonymous = true;
        omitPasswordAuth = true;
      }
    ];
  };
  systemd.services.owntracks = {
    enable = true;
    description = "owntracks recorder";
    serviceConfig = {
      ExecStart = ''
        ${pkgs.owntracks-recorder}/bin/ot-recorder \
           --storage /var/lib/owntracks/recorder/store \
           --port 1884 \
           --http-host [::] \
           'owntracks/#'
      '';
      DynamicUser = true;
      StateDirectory = "owntracks";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };

  networking.firewall.allowedTCPPorts = [
    8083
    1883
  ];
}
