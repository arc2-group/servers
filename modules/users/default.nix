{
  username,
  ...
}:
{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      (builtins.readFile ../../hosts/vm-admin/id_ed25519.pub)
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpmdkxAZH3See4FaPgiZoTxpcEC1orOGB9cXoQtYUYI"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDGk2s3Q7/djy4ytAQUBpVuo+97yQz9p4tzREX+vujoy"
    ];
  };

  security.sudo = {
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };
}
