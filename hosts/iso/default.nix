{
  modulesPath,
  lib,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";
}
