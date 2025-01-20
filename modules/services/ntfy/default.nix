{ ... }:
{
  ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://ntfy.blazma.st";
      cahce-file = "/var/cache/ntfy/cache.db";
      auth-file = "/var/lib/nitfy/user.db";
      behind-proxy = "true";
      visitor-subscriber-rate-limiting = true;
      upstream-base-url = "https://ntfy.sh";

    };
  };
}
