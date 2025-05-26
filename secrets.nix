let
  admins = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDGk2s3Q7/djy4ytAQUBpVuo+97yQz9p4tzREX+vujoy"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIiiNmXma1IijIE6U6CKsGcmfGf0gqSZ5S0fvZABv+tA"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpmdkxAZH3See4FaPgiZoTxpcEC1orOGB9cXoQtYUYI"
    s.vm-admin
  ];

  # Read ./hosts directory to get a list of systems
  entries = builtins.readDir ./hosts;
  configurations = builtins.filter (
    name: entries.${name} == "directory" && builtins.pathExists ./hosts/${name}/ssh_host_ed25519_key.pub
  ) (builtins.attrNames entries);

  # Build a set of attributes mapping system names to its public key (read from each system’s file)
  s = builtins.listToAttrs (
    map (name: {
      inherit name;
      value = builtins.readFile ./hosts/${name}/ssh_host_ed25519_key.pub;
    }) configurations
  );

  # Generate an attribute set with keys like "hosts/<vm>/ssh_host_ed25519_key.age"
  secrets = builtins.listToAttrs (
    map (vm: {
      # Here vm is just a string, the host name
      name = "hosts/" + vm + "/ssh_host_ed25519_key.age";
      value = {
        publicKeys = admins ++ [ s.${vm} ];
      };
    }) configurations
  );

in
{
  "hosts/vm-admin/id_ed25519.age".publicKeys = admins;
  "hosts/vm-admin/ssh_host_ed25519_key.age".publicKeys = admins;

  "modules/services/navidrome/secrets.env.age".publicKeys = admins ++ [ s.vm-public-media ];
  "modules/services/slskd/secrets.env.age".publicKeys = admins ++ [ s.vm-public-media ];
  "hosts/vm-public-matrix/ssh_host_ed25519_key.age".publicKeys = admins ++ [ s.vm-public-matrix ];
  "modules/services/continuwuity/registration-token.age".publicKeys = admins ++ [
    s.vm-public-matrix
  ];
  "hosts/vm-monitoring/ssh_host_ed25519_key.age".publicKeys = admins ++ [ s.vm-monitoring ];
  "modules/services/monitoring/grafana/admin-password.age".publicKeys = admins ++ [
    s.vm-monitoring
  ];
}
// secrets
