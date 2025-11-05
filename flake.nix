{
  inputs = {
    nixpkgs_latest.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs_unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs_latest";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs_latest";

    nixarr.url = "github:rasmus-kirk/nixarr";
    nixarr.inputs.nixpkgs.follows = "nixpkgs_latest";

    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs_latest";
    };

    blank.url = "github:divnix/blank";

    continuwuity = {
      url = "git+https://forgejo.ellis.link/continuwuation/continuwuity";
      inputs = {
        attic.follows = "blank";
        cachix.follows = "blank";
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

    gancio-plugin-discord = {
      url = "git+https://git.gay/QueerResourcesRiga/gancio-plugin-discord";
      inputs.nixpkgs.follows = "nixpkgs_latest";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://arc2-group.cachix.org"
    ];
    extra-trusted-public-keys = [
      "arc2-group.cachix.org-1:SfZ4Amg/VroYhmCRNX0mQcFEWGCFWvn31s3gwEaU/2U="
    ];
  };

  outputs =
    {
      self,
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
      vms = builtins.filter (name: builtins.substring 0 3 name == "vm-") configurations;
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (name: {
          inherit name;
          value = helper.mkNixos {
            hostname = name;
            username = vmUsername;
            inherit vms;
          };
        }) configurations
      );
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
        }
        // builtins.listToAttrs (
          map (name: {
            name = "host-${name}";
            value = self.nixosConfigurations.${name}.config.system.build.toplevel;
          }) configurations
        );

        devShells.default = pkgs.mkShell {
          buildInputs = self.checks.${system}.pre-commit.enabledPackages;
          inherit (self.checks.${system}.pre-commit) shellHook;

          packages = with pkgs; [
            git
            direnv
            inputs.agenix.outputs.packages.${system}.default
            ssh-to-age
            openssl
            ansible
            nixos-anywhere
            nixos-generators
            cachix
          ];
        };
      }
    );
}
