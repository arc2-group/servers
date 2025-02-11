{ config, ... }:
{
  services.prometheus.exporters.node = {
    enable = true;
    listenAddress = "[::]";
    port = 9100;
  };
  services.prometheus.exporters.systemd = {
    enable = true;
    listenAddress = "[::]";
    port = 9558;
  };

  networking.firewall.allowedTCPPorts = [
    config.services.prometheus.exporters.node.port
    config.services.prometheus.exporters.systemd.port
  ];
}
