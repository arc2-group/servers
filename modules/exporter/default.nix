{
  config,
  hostname,
  outputs,
  ...
}:
let
  alloyPort = 28183;
  lokiPort =
    outputs.nixosConfigurations.vm-monitoring.config.services.loki.configuration.server.http_listen_port;
in
{
  services = {
    prometheus.exporters = {
      node = {
        enable = true;
        listenAddress = "[::]";
        port = 9100;
      };
      systemd = {
        enable = true;
        listenAddress = "[::]";
        port = 9558;
      };
    };

    # Alloy for sending logs to Loki
    alloy = {
      enable = true;
      configPath = "/etc/alloy";
      extraFlags = [
        "--server.http.listen-addr=[::]:${toString alloyPort}"
      ];
    };
  };

  # Alloy config
  # when no configuration options in module :(
  environment.etc."alloy/config.alloy".text = ''
    discovery.relabel "journal" {
    	targets = []

    	rule {
    		source_labels = ["__journal__systemd_unit"]
    		target_label  = "unit"
    	}
    }

    loki.source.journal "journal" {
    	max_age       = "12h0m0s"
    	relabel_rules = discovery.relabel.journal.rules
    	forward_to    = [loki.write.default.receiver]
    	labels        = {
    		host = "${hostname}",
    		job  = "systemd-journal",
    	}
    }

    loki.write "default" {
    	endpoint {
    		url = "http://vm-monitoring:${toString lokiPort}/loki/api/v1/push"
    	}
    	external_labels = {}
    }
  '';

  networking.firewall.allowedTCPPorts = [
    config.services.prometheus.exporters.node.port
    config.services.prometheus.exporters.systemd.port
    alloyPort
  ];
}
