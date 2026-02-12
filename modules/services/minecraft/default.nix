{ inputs, pkgs, ... }:
let
  modpack = pkgs.fetchPackwizModpack {
    src =
      pkgs.fetchFromGitHub {
        owner = "arc2-group";
        repo = "qminecraft-modpack";
        rev = "fef2591eda5414c8b71b3ddf30a8483fa52a08cd";
        hash = "sha256-HL/goGy8PGCb3uaUw0d6OQ1GN0UpU4qdpaSQJsSeOiI=";
      }
      + /src;
    packHash = "sha256-52jX0dY9gTya+5XFCWrp1lpYSOGJ/iYuDrfcCtYuWbA=";
  };
in
{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
    ./logs
  ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers = {
      queer-minecraft = {
        enable = true;
        package = pkgs.fabricServers.fabric-1_21_11;
        serverProperties = {
          difficulty = "normal";
          enable-code-of-conduct = true;
          enforce-secure-profile = false;
          hide-online-players = true;
          motd = "A§4 lo§fc§4al §bq§du§fe§de§br §4M§ci§6n§ee§ac§3r§ba§9f§1t §ew§fo§9r§8ld\\n§fin §91.21.11§f!";
          level-seed = "-8021755361276700313";
          spawn-protection = 0;
          server-port = 35585;
        };
        files = {
          "mods" = "${modpack}/mods";
          "mods/luckperms" = "${modpack}/luckperms";
          "config" = "${modpack}/config";
          "codeofconduct" = "${modpack}/codeofconduct";
        };
        jvmOpts = "-Xms4096M -Xmx10240M";
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      35585 # Minecraft
      8100 # BlueMap
      25585 # Prometheus exporter
    ];
    allowedUDPPorts = [
      35585 # Bedrock
      24454 # Simple Voice Chat
    ];
  };

  allowed-unfree = [ "minecraft-server" ];
}
