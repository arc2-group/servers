{
  outputs,
  vms,
  ...
}:
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

  alloyTargets = map (vm: "${vm}:28183") vms;
in
{
  services.prometheus = {
    enable = true;
    listenAddress = "[::1]";
    port = 9090;
    retentionTime = "31d";

    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [ { targets = nodeTargets; } ];
      }
      {
        job_name = "systemd";
        static_configs = [ { targets = systemdTargets; } ];
      }
      {
        job_name = "alloy";
        static_configs = [ { targets = alloyTargets; } ];
      }
      {
        job_name = "nginx";
        static_configs = [ { targets = [ "vm-public-ingress:9113" ]; } ];
      }
      {
        job_name = "minecraft";
        static_configs = [ { targets = [ "vm-public-qminecraft:25585" ]; } ];
        scrape_interval = "10s";
      }
    ];
  };
}
