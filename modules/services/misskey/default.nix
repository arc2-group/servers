{ pkgs, config, hostname, inputs, platform, ... }:
{
  services.misskey = {
    enable = true;
    settings = {
      # setupPassword = example_password_please_change_this_or_you_will_get_hacked;
      url = https://social.blazma.st/;
      db = {
        host = "social.blazma.st";
      };
    };
  };
};
