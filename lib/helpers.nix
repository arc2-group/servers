{
  inputs,
  outputs,
  stateVersion,
  ...
}:
{
  mkNixos =
    {
      hostname,
      username,
      platform ? "x86_64-linux",
      vms,
    }:
    let
      isISO = builtins.substring 0 3 hostname == "iso";
      isInstall = !isISO;

      unstable = import inputs.nixpkgs_unstable {
        system = platform;
      };

    in
    inputs.nixpkgs_latest.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          outputs
          hostname
          platform
          username
          stateVersion
          isISO
          isInstall
          vms
          unstable
          ;
      };
      modules = [
        ../hosts
        ./unfree.nix
      ];
    };

  forAllSystems = inputs.nixpkgs_latest.lib.genAttrs [
    "aarch64-linux"
    "x86_64-linux"
  ];
}
