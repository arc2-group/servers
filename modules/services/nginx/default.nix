{ config, ... }:
{
  services = {
    nginx = {
      enable = true;

      # Use recommended settings
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      # Only allow PFS-enabled ciphers with AES256
      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

      appendHttpConfig = ''
        ssl_client_certificate ${./ssl_client_certificate.crt};
        ssl_verify_client optional;
      '';

      commonHttpConfig = ''
        log_format json_analytics escape=json '{'
        '"msec": "$msec", ' # request unixtime in seconds with a milliseconds resolution
        '"connection": "$connection", ' # connection serial number
        '"connection_requests": "$connection_requests", ' # number of requests made in connection
        '"request_id": "$request_id", ' # the unique request id
        '"request_length": "$request_length", ' # request length (including headers and body)
        '"remote_addr": "$remote_addr", ' # client IP
        '"remote_port": "$remote_port", ' # client port
        '"time_iso8601": "$time_iso8601", ' # local time in the ISO 8601 standard format
        '"request_uri": "$request_uri", ' # full path and arguments if the request
        '"status": "$status", ' # response status code
        '"body_bytes_sent": "$body_bytes_sent", ' # the number of body bytes exclude headers sent to a client
        '"bytes_sent": "$bytes_sent", ' # the number of bytes sent to a client
        '"http_referer": "$http_referer", ' # HTTP referer
        '"http_user_agent": "$http_user_agent", ' # user agent
        '"http_x_forwarded_for": "$http_x_forwarded_for", ' # http_x_forwarded_for
        '"http_host": "$http_host", ' # the request Host: header
        '"server_name": "$server_name", ' # the name of the vhost serving the request
        '"request_time": "$request_time", ' # request processing time in seconds with msec resolution
        '"upstream": "$upstream_addr", ' # upstream backend server for proxied requests
        '"upstream_connect_time": "$upstream_connect_time", ' # upstream handshake time incl. TLS
        '"upstream_header_time": "$upstream_header_time", ' # time spent receiving upstream headers
        '"upstream_response_time": "$upstream_response_time", ' # time spent receiving upstream body
        '"upstream_response_length": "$upstream_response_length", ' # upstream response length
        '"upstream_cache_status": "$upstream_cache_status", ' # cache HIT/MISS where applicable
        '"ssl_protocol": "$ssl_protocol", ' # TLS protocol
        '"ssl_cipher": "$ssl_cipher", ' # TLS cipher
        '"scheme": "$scheme", ' # http or https
        '"request_method": "$request_method", ' # request method
        '"server_protocol": "$server_protocol", ' # request protocol, like HTTP/1.1 or HTTP/2.0
        '"pipe": "$pipe", ' # "p" if request was pipelined, "." otherwise
        '"gzip_ratio": "$gzip_ratio"'
        '}';

        access_log /var/log/nginx/json_access.log json_analytics;
      '';

      # Status page for Prometheus Nginx exporter
      statusPage = true;
    };

    # Prometheus metrics for Nginx
    prometheus.exporters.nginx = {
      enable = true;
      port = 9113;
      listenAddress = "[::]";
    };

    # logrotate to delete locally saved logs
    logrotate.enable = true;
    logrotate.settings.nginx = {
      frequency = "daily";
      rotate = 0; # don't keep anything
    };
  };

  # Server certificates
  security.acme = {
    acceptTerms = true;
    defaults.email = "yam-divided-casino@duck.com";
  };

  imports = [
    ./vhosts
  ];

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
      config.services.prometheus.exporters.nginx.port
    ];
    allowedUDPPorts = [ 443 ];
  };

  # Alloy for sending Nginx logs
  systemd.services.alloy.reloadTriggers = [ config.environment.etc."alloy/nginx.alloy".source ];
  environment.etc."alloy/nginx.alloy".text = ''
    local.file_match "logs_integrations_integrations_nginx" {
      path_targets = [{
        __address__ = "localhost",
        __path__    = "/var/log/nginx/json_access.log",
        host        = "<http_hostname>",
        instance    = constants.hostname,
        job         = "integrations/nginx",
      }]
    }

    loki.source.file "logs_integrations_integrations_nginx" {
      targets    = local.file_match.logs_integrations_integrations_nginx.targets
      forward_to = [loki.write.default.receiver]
    }
  '';
}
