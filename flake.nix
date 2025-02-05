{
  inputs = {
    nixpkgs_latest.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs_unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs_latest";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs_latest";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs_latest";

    nixarr.url = "github:rasmus-kirk/nixarr";
    nixarr.inputs.nixpkgs.follows = "nixpkgs_latest";

    blank.url = "github:divnix/blank";

    conduwuit.url = "github:girlbossceo/conduwuit";
    conduwuit.inputs.attic.follows = "blank";
    conduwuit.inputs.cachix.follows = "blank";
    conduwuit.inputs.complement.follows = "blank";
    conduwuit.inputs.flake-compat.follows = "blank";
  };
  outputs = { self, nixpkgs_latest, nixpkgs_unstable, deploy-rs, ... }@inputs:
    let
      inherit (self) outputs;
      stateVersion = "24.11";
      helper = import ./lib { inherit inputs outputs stateVersion; };
      vmUsername = "coil";
    in
    {
      nixosConfigurations = {
        vm-admin = helper.mkNixos {
          hostname = "vm-admin";
          username = vmUsername;
        };
        vm-public-ingress = helper.mkNixos {
          hostname = "vm-public-ingress";
          username = vmUsername;
        };
        vm-public-media = helper.mkNixos {
          hostname = "vm-public-media";
          username = vmUsername;
        };
        vm-public-matrix = helper.mkNixos {
          hostname = "vm-public-matrix";
          username = vmUsername;
        };
        # Special configs
        vm-minimal = helper.mkNixos {
          hostname = "vm-minimal";
          username = vmUsername;
        };
        iso = helper.mkNixos {
          hostname = "iso";
          username = vmUsername;
        };
      };

      deploy.nodes = {
        # TODO: use hostnames instead of hardcoded IPs
        vm-admin = {
          hostname = "fd5e:934f:acab:ffff::6001";
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.vm-admin;
          profiles.system.user = "root";
          profiles.system.sshUser = vmUsername;
        };
        vm-public-ingress = {
          hostname = "fd5e:934f:acab:ffff::6003";
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.vm-public-ingress;
          profiles.system.user = "root";
          profiles.system.sshUser = vmUsername;
        };
        vm-public-media = {
          hostname = "fd5e:934f:acab:ffff::6002";
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.vm-public-media;
          profiles.system.user = "root";
          profiles.system.sshUser = vmUsername;
        };
        vm-public-matrix = {
          hostname = "fd5e:934f:acab:ffff::6005";
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.vm-public-matrix;
          profiles.system.user = "root";
          profiles.system.sshUser = vmUsername;
        };

        # Template VM
        #vm-minimal = {
        #  hostname = "fdc6:b53a:280e:095::2000";
        #  profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos #self.nixosConfigurations.vm-admin;
        #  profiles.system.user = "root";
        #  profiles.system.sshUser = vmUsername;
        #};
      };

      nixConfig = {
        extra-substituters = [
          "https://arc2-group.cachix.org"
        ];
        extra-trusted-public-keys = [
          "arc2-group.cachix.org-1:SfZ4Amg/VroYhmCRNX0mQcFEWGCFWvn31s3gwEaU/2U="
        ];
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
