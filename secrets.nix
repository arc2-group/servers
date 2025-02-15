let
  a1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpmdkxAZH3See4FaPgiZoTxpcEC1orOGB9cXoQtYUYI";
  a2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIiiNmXma1IijIE6U6CKsGcmfGf0gqSZ5S0fvZABv+tA";
  a3 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDGk2s3Q7/djy4ytAQUBpVuo+97yQz9p4tzREX+vujoy";

  admins = [
    a1
    a2
    a3
  ];

  vm-admin = builtins.readFile ./hosts/vm-admin/ssh_host_ed25519_key.pub;
  vm-minimal = builtins.readFile ./hosts/vm-minimal/ssh_host_ed25519_key.pub;
  vm-public-ingress = builtins.readFile ./hosts/vm-public-ingress/ssh_host_ed25519_key.pub;
  vm-public-media = builtins.readFile ./hosts/vm-public-media/ssh_host_ed25519_key.pub;
  vm-public-matrix = builtins.readFile ./hosts/vm-public-matrix/ssh_host_ed25519_key.pub;
  vm-public-social = builtins.readFile ./hosts/vm-public-social/ssh_host_ed25519_key.pub;

  systems = [
    vm-admin
    vm-minimal
  ];
  everyone = systems ++ admins;
in
{
  "hosts/vm-admin/id_ed25519.age".publicKeys = everyone;
  "hosts/vm-admin/ssh_host_ed25519_key.age".publicKeys = everyone;

  "hosts/vm-minimal/ssh_host_ed25519_key.age".publicKeys = everyone;

  "hosts/vm-public-ingress/ssh_host_ed25519_key.age".publicKeys = [ vm-public-ingress ] ++ everyone;

  "hosts/vm-public-media/ssh_host_ed25519_key.age".publicKeys = [ vm-public-media ] ++ everyone;
  "modules/services/navidrome/secrets.env.age".publicKeys = [ vm-public-media ] ++ everyone;

  "hosts/vm-public-matrix/ssh_host_ed25519_key.age".publicKeys = [ vm-public-matrix ] ++ everyone;
  "modules/services/conduwuit/registration-token.age".publicKeys = [ vm-public-matrix ] ++ everyone;

  "hosts/vm-public-social/ssh_host_ed25519_key.age".publicKeys = [ vm-public-social ] ++ everyone;
  "modules/services/peertube/secrets.age".publicKeys = [ vm-public-social ] ++ everyone;
  "modules/services/peertube/db-password.age".publicKeys = [ vm-public-social ] ++ everyone;
  "modules/services/peertube/redis-password.age".publicKeys = [ vm-public-social ] ++ everyone;
}
