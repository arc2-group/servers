{ outputs, vms, ... }:
let
  nodeTargets = map (
    vm:
    let
      vmConfig = outputs.nixosConfigurations.${vm}.config;
      port = toString vmConfig.services.prometheus.exporters.node.port;
    in
    "${vm}:${port}"
  ) vms;

  systemdTargets = map (
    vm:
    let
      vmConfig = outputs.nixosConfigurations.${vm}.config;
      port = toString vmConfig.services.prometheus.exporters.systemd.port;
    in
    "${vm}:${port}"
  ) vms;
in
{
  services.prometheus = {
    enable = true;
    listenAddress = "[::1]";
    port = 9090;

    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [ { targets = nodeTargets; } ];
      }
      {
        job_name = "systemd";
        static_configs = [ { targets = systemdTargets; } ];
      }
    ];
  };
}
