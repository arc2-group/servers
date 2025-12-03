{ config, hostname, ... }:
let
  logsDir = "${config.services.minecraft-servers.dataDir}/queer-minecraft/logs";
  inherit (config.services.minecraft-servers) group;
in
{
  environment.etc."alloy/minecraft.alloy".text = ''
    local.file_match "local_files" {
      path_targets = [{ "__path__" = "${logsDir}/latest.log", job = "minecraft", server="queer-minecraft", host = "${hostname}"  }]
      sync_period  = "5s"
    }

    loki.source.file "log_scrape" {
      targets       = local.file_match.local_files.targets
      forward_to    = [loki.write.default.receiver]
      tail_from_end = true
    }
  '';

  systemd.services.alloy.serviceConfig.SupplementaryGroups = [ group ];
}
