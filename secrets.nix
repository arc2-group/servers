let
  a1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpmdkxAZH3See4FaPgiZoTxpcEC1orOGB9cXoQtYUYI";

  admins = [ a1 ];

  vm-admin = (builtins.readFile ./hosts/vm-admin/ssh_host_ed25519_key.pub);
  vm-minimal = (builtins.readFile ./hosts/vm-minimal/ssh_host_ed25519_key.pub);

  systems = [ vm-admin ];
  everyone = systems ++ admins;
in
{
  "hosts/vm-admin/id_ed25519.age".publicKeys = [ vm-admin ] ++ admins;
  "hosts/vm-admin/ssh_host_ed25519_key.age".publicKeys = [ vm-admin ] ++ admins;

  "hosts/vm-minimal/ssh_host_ed25519_key.age".publicKeys = [ vm-admin vm-minimal ] ++ admins;
}
