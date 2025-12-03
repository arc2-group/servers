{ config, pkgs, ... }:
{
  services = {
    nginx = {
      enable = true;

      additionalModules = [
        pkgs.nginxModules.geoip2
      ];

      # Use recommended settings
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      # Only allow PFS-enabled ciphers with AES256
      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

      appendHttpConfig = ''
        ssl_client_certificate ${./ssl_client_certificate.crt};

        map $ssl_client_s_dn $permissions {
          default "";
          "~*CN=suffocate3069" "admin";
          "~*CN=condone4519" "admin";
          "~*CN=uneasy8119" "admin";
          "~*CN=muster4333" "admin";

          "~*CN=LatviaFM" "pve";
        }

        geoip2 /var/lib/GeoIP/GeoLite2-Country.mmdb {
          auto_reload 5m;
          $geoip2_data_country_code country iso_code;
        }

        geoip2 /var/lib/GeoIP/GeoLite2-City.mmdb {
          auto_reload 5m;
          $geoip2_data_city_name city names en;
          $geoip2_data_lat location latitude;
          $geoip2_data_lon location longitude;
        }

        geoip2 /var/lib/GeoIP/GeoLite2-ASN.mmdb {
          auto_reload 5m;
          $geoip2_data_asn autonomous_system_number;
          $geoip2_data_asorg autonomous_system_organization;
        }

        log_format json_analytics escape=json '{'
          '"connection": "$connection", ' # connection serial number
          '"connection_requests": "$connection_requests", ' # number of requests made in connection
          '"pid": "$pid", ' # process pid
          '"request_id": "$request_id", ' # the unique request id
          '"request_length": "$request_length", ' # request length (including headers and body)
          '"remote_addr": "$remote_addr", ' # client IP
          '"remote_user": "$remote_user", ' # client HTTP username
          '"remote_port": "$remote_port", ' # client port
          '"time_local": "$time_local", '
          '"time_iso8601": "$time_iso8601", ' # local time in the ISO 8601 standard format
          '"request": "$request", ' # full path no arguments if the request
          '"request_uri": "$request_uri", ' # full path and arguments if the request
          '"args": "$args", ' # args
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
          '"upstream_response_time": "$upstream_response_time", ' # time spend receiving upstream body
          '"upstream_response_length": "$upstream_response_length", ' # upstream response length
          '"upstream_cache_status": "$upstream_cache_status", ' # cache HIT/MISS where applicable
          '"ssl_protocol": "$ssl_protocol", ' # TLS protocol
          '"ssl_cipher": "$ssl_cipher", ' # TLS cipher
          '"scheme": "$scheme", ' # http or https
          '"request_method": "$request_method", ' # request method
          '"server_protocol": "$server_protocol", ' # request protocol, like HTTP/1.1 or HTTP/2.0
          '"pipe": "$pipe", ' # "p" if request was pipelined, "." otherwise
          '"gzip_ratio": "$gzip_ratio", '
          '"http_cf_ray": "$http_cf_ray",'
          '"geoip_country_code": "$geoip2_data_country_code",'
          '"geoip_city": "$geoip2_data_city_name",'
          '"geoip_asn": "$geoip2_data_asn",'
          '"geoip_asorg": "$geoip2_data_asorg"'
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
    ./alloy
    ./geoip
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
}
