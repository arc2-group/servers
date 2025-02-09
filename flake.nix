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

    conduwuit = {
      url = "github:girlbossceo/conduwuit";
      inputs = {
        attic.follows = "blank";
        cachix.follows = "blank";
        complement.follows = "blank";
        flake-compat.follows = "blank";
        flake-utils.follows = "flake-utils";
      };
    };

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
      inputs.flake-compat.follows = "blank";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs_unstable,
      deploy-rs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      stateVersion = "24.11";
      helper = import ./lib { inherit inputs outputs stateVersion; };
      vmUsername = "coil";

      # Build list of configurations (each directory in ./hosts)
      entries = builtins.readDir ./hosts;
      configurations = builtins.filter (entry: entries.${entry} == "directory") (
        builtins.attrNames entries
      );

      # Generate deploy-rs config
      deployNodes = builtins.listToAttrs (
        map
          (name: {
            inherit name;
            value = {
              hostname = name;
              profiles.system = {
                path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.${name};
                system.user = "root";
                system.sshUser = vmUsername;
              };
            };
          })
          # Only deploy VMs (hosts that start with 'vm-')
          (builtins.filter (name: builtins.substring 0 3 name == "vm-") configurations)
      );
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (name: {
          inherit name;
          value = helper.mkNixos {
            hostname = name;
            username = vmUsername;
          };
        }) configurations
      );

      deploy.nodes = deployNodes;

      nixConfig = {
        extra-substituters = [
          "https://arc2-group.cachix.org"
        ];
        extra-trusted-public-keys = [
          "arc2-group.cachix.org-1:SfZ4Amg/VroYhmCRNX0mQcFEWGCFWvn31s3gwEaU/2U="
        ];
      };
    }
    // inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs_unstable {
          inherit system;
        };
      in
      {
        checks = {
          pre-commit = inputs.pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixfmt-rfc-style.enable = true;
              deadnix.enable = true;
              nil.enable = true;
              statix.enable = true;
              ansible-lint.enable = true;
              ansible-lint.settings.subdir = "./ansible";
              markdownlint.enable = true;
            };
          };
        } // (inputs.deploy-rs.lib.${system}.deployChecks self.deploy);

        devShells.default = pkgs.mkShell {
          buildInputs = self.checks.${system}.pre-commit.enabledPackages;
          inherit (self.checks.${system}.pre-commit) shellHook;

          packages = with pkgs; [
            git
            direnv
            agenix-cli
            ssh-to-age
            openssl
            ansible
            nixos-anywhere
            nixos-generators
          ];
        };
      }
    );
}
