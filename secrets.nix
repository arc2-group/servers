let
  a1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpmdkxAZH3See4FaPgiZoTxpcEC1orOGB9cXoQtYUYI";

  admins = [ a1 ];

  vm-admin = (builtins.readFile ./hosts/vm-admin/ssh_host_ed25519_key.pub);
  vm-minimal = (builtins.readFile ./hosts/vm-minimal/ssh_host_ed25519_key.pub);
  vm-public-ingress = (builtins.readFile ./hosts/vm-public-ingress/ssh_host_ed25519_key.pub);
  vm-public-media = (builtins.readFile ./hosts/vm-public-media/ssh_host_ed25519_key.pub);

  systems = [ vm-admin vm-minimal ];
  everyone = systems ++ admins;
in
{
  "hosts/vm-admin/id_ed25519.age".publicKeys = everyone;
  "hosts/vm-admin/ssh_host_ed25519_key.age".publicKeys = everyone;

  "hosts/vm-minimal/ssh_host_ed25519_key.age".publicKeys = everyone;

  "hosts/vm-public-ingress/ssh_host_ed25519_key.age".publicKeys = [ vm-public-ingress ] ++ everyone;

  "hosts/vm-public-media/ssh_host_ed25519_key.age".publicKeys = [ vm-public-media ] ++ everyone;
}
