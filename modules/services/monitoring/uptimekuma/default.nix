_:
let
  port = 3001;
in
{
  services.uptime-kuma = {
    enable = true;
    settings = {
      PORT = toString port;
      HOST = "::";
    };
  };

  networking.firewall.allowedTCPPorts = [ port ];
}
