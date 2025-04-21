{ hostname, config, ... }:
let
  secrets = "${hostname}-slskd-secrets";
in
{
  services.slskd = {
    enable = true;
    openFirewall = true;
    group = "media";
    environmentFile = config.age.secrets.${secrets}.path;
    domain = null;
    settings = {
      directories = {
        downloads = "/media/slskd/downloads";
        incomplete = "/media/slskd/incomplete";
      };
      shares = {
        directories = [
          "/media/library/books"
          "/media/library/movies"
          "/media/library/music"
          "/media/library/shows"
        ];
      };
      soulseek = {
        listen_port = 50300;
      };
      web = {
        port = 5030;
      };
      remote_file_management = true;
    };
  };

  age.secrets.${secrets} = {
    file = ./secrets.env.age;
  };
}
