{ hostname, ... }:
{
  environment.etc."alloy/nginx.alloy".text = ''
    local.file_match "local_files" {
      path_targets = [{ "__path__" = "/var/log/nginx/json_access.log", job = "nginx", host = "${hostname}"  }]
      sync_period  = "5s"
    }

    loki.source.file "log_scrape" {
      targets       = local.file_match.local_files.targets
      forward_to    = [loki.write.default.receiver]
      tail_from_end = true
    }
  '';

  systemd.services.alloy.serviceConfig.SupplementaryGroups = [ "nginx" ];
}
