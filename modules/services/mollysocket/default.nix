{ ... }:
{
  mollysocket = {
    enable = true;
    settings = {
      db = "/var/lib/mollysocket/molly.sqlite";
      host = "::";
      allowed_endpoints = [ "https://ntfy.sh" "https://ntfy.blazma.st" "*" ];
    };
  };
}
