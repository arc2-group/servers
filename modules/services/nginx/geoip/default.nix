{ config, ... }:
{
  services.geoipupdate = {
    enable = true;
    settings = {
      AccountID = 1264102;
      EditionIDs = [
        "GeoLite2-ASN"
        "GeoLite2-City"
        "GeoLite2-Country"
      ];
      LicenseKey = config.age.secrets.geoip-license-key.path;
    };
  };

  age.secrets.geoip-license-key = {
    file = ./license.age;
  };
}
