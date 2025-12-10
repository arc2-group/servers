{ inputs, pkgs, ... }:
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
        package = pkgs.fabricServers.fabric-1_21_10;
        serverProperties = {
          difficulty = "normal";
          enable-code-of-conduct = true;
          enforce-secure-profile = false;
          hide-online-players = true;
          motd = "A§4 lo§fc§4al §bq§du§fe§de§br §4M§ci§6n§ee§ac§3r§ba§9f§1t §ew§fo§9r§8ld\\n§fnow with the §d§oSimple Voice Chat§f mod";
          level-seed = "-8021755361276700313";
          spawn-protection = 0;
          server-port = 35585;
        };
        symlinks = {
          mods = pkgs.linkFarmFromDrvs "mods" (
            builtins.attrValues {
              # API
              Fabric-API = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/dQ3p80zK/fabric-api-0.138.3%2B1.21.10.jar";
                hash = "sha256-rCB1kEGet1BZqpn+FjliQEHB1v0Ii6Fudi5dfs9jOVM=";
              };
              Kotlin = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/LcgnDDmT/fabric-language-kotlin-1.13.7%2Bkotlin.2.2.21.jar";
                hash = "sha256-d5UZY+3V19N+5PF0431GqHHkW5c0JvO0nWclyBm0uPI=";
              };
              # Performance optimization
              FerriteCore = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/uXXizFIs/versions/MGoveONm/ferritecore-8.0.2-fabric.jar";
                hash = "sha256-LGn9gXMEu2l1zUti/TK/IaXVyPDDUj6sxzTAwlB+2nc=";
              };
              Lithium = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/NsswKiwi/lithium-fabric-0.20.1%2Bmc1.21.10.jar";
                hash = "sha256-R4Z0hlDjXdFlcrhenM0YOadgbATGdqWbZEUOhEadKJo=";
              };
              VMP = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/wnEe9KBa/versions/nCucW7Sl/vmp-fabric-mc1.21.10-0.2.0%2Bbeta.7.217-all.jar";
                hash = "sha256-lMUQYg8EEVXhOcKgqbkWh6YoDSx0ZeALQLUVcGXqiAM=";
              };
              c2me = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/VSNURh3q/versions/uNick7oj/c2me-fabric-mc1.21.10-0.3.5.1.0.jar";
                hash = "sha256-pqUSN/OqZOF7p3g/iKO71c2830/eDg7OsFkhZ0AR9GQ=";
              };
              Krypton = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/O9LmWYR7/krypton-0.2.10.jar";
                hash = "sha256-lCkdVpCgztf+fafzgP29y+A82sitQiegN4Zrp0Ve/4s=";
              };
              ScalableLux = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/Ps1zyz6x/versions/PV9KcrYQ/ScalableLux-0.1.6%2Bfabric.c25518a-all.jar";
                hash = "sha256-ekpzcThhg8dVUjtWtVolHXWsLCP0Cvik8PijNbBdT8I=";
              };
              # Security
              Ledger = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/LVN9ygNV/versions/O4Rna8OX/ledger-1.3.16.jar";
                hash = "sha256-7fw94C87iu/0T+knZqeYGr+9lNPNZX/Af1xTWrQcru0=";
              };
              GrimAC = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/LJNGWSvH/versions/7yXLPvDc/grimac-fabric-2.3.73-c2c044f.jar";
                hash = "sha256-HLuiZv6foxY2XDaiME2hPM3Q+iex0ZsMeP+XPzLcA/E=";
              };
              SneakyServer = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/HRXgZcrv/versions/tQ1XxByg/sneaky-mc1.21.10-1.0.19.jar";
                hash = "sha256-imtDLRquqtwzn00pYN2Iwfjtt+WS7LWeHZnGA4Ws6Do=";
              };
              Vanish = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/UL4bJFDY/versions/cc67BUWK/vanish-1.6.2%2B1.21.10.jar";
                hash = "sha256-bt2drKRv2aS9oL2XYcDGOfYBBJUkbgASsA94rqa63Xg=";
              };
              # Offline mode
              SkinsRestorer = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/TsLS8Py5/versions/LdrviBBO/SkinsRestorer-Mod-15.9.0-fabric.jar";
                hash = "sha256-5Je3Qv/QiVSjkpv9A4UERRC4P5oQsbSPwI7t1yBIQC0=";
              };
              EasyAuth = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/aZj58GfX/versions/4ymSCTJS/easyauth-mc1.21.9-3.4.0.jar";
                hash = "sha256-/QbS8YOdfdNsmJiPYtlsClBEWDAbl6DNtQTez/6nQDc=";
              };
              EasyWhitelist = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/LODybUe5/versions/gcFPDYmw/easywhitelist-1.1.1.jar";
                hash = "sha256-54aai5cApXBctydXRZqwU4PXCs3sfn6kLo6BJuwV2Ko=";
              };
              # Protocol
              Geyser = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/wKkoqHrH/versions/Tyrnrthu/geyser-fabric-Geyser-Fabric-2.9.1-b1002.jar";
                hash = "sha256-GUxanh1zWZcgKKQmy8ej6OHnu4jONn+j1s39uEdolT0=";
              };
              Floodgate = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/bWrNNfkb/versions/QFAMeMNB/Floodgate-Fabric-2.2.6-b51.jar";
                hash = "sha256-lC1p+q8ra1j6TTRxYdix4t7vC3ctWPM0FLrxlixscp0=";
              };
              # Debug
              NEC = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/yM94ont6/versions/6MLxKD6g/notenoughcrashes-fabric-4.4.9%2B1.21.10.jar";
                hash = "sha256-vvcG/9Iwkk0mMBya8OU+8tWvseaH+nELnIxP1zbfLcU=";
              };
              Spark = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/l6YH9Als/versions/eqIoLvsF/spark-1.10.152-fabric.jar";
                hash = "sha256-Ul2oR/N2zraVvPGxWs8YbHWQu1fiBt+a9CEIUnpP/Z4=";
              };
              FabricExporter = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/dbVXHSlv/versions/OT2QwJUv/fabricexporter-1.0.19.jar";
                hash = "sha256-q+wuL79x2XnMlowm3elVzOFQ585h4U+8/c5Jo7ETFw4=";
              };
              # Map
              BlueMap = pkgs.fetchurl {
                url = "https://github.com/BlueMap-Minecraft/BlueMap/releases/download/v5.13/bluemap-5.13-fabric.jar";
                hash = "sha256-VO2zE+cHkZGZ0O1Rf/OUZnO0sh1PAKH+HzH6ApTFMoo=";
              };
              # Voice Chat
              SimpleVoiceChat = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/BjR2lc4k/voicechat-fabric-1.21.10-2.6.6.jar";
                hash = "sha256-yC5pMBLsi4BnUq4CxTfwe4MGTqoBg04ZaRrsBC3Ds3Y=";
              };
            }
          );
        };
        files = {
          "config/GrimAC/config.yml" = ./config/GrimAC/config.yml;
          "config/Geyser-Fabric/config.yml" = ./config/Geyser-Fabric/config.yml;
          "config/EasyAuth" = ./config/EasyAuth;
          "config/bluemap" = ./config/bluemap;
          "codeofconduct" = ./codeofconduct;
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
