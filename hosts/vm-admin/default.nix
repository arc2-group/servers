{ config
, pkgs
, username
, ...
}:

{
  environment.systemPackages = with pkgs; [
    nixos-anywhere
    nixos-generators
    deploy-rs
  ];

  systemd.services.clone-repo = {
    description = "Clone Git Repository";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = username;
    };
    script = ''
      #!/usr/bin/env bash
      echo Cloning repo...
      ${pkgs.git}/bin/git clone https://github.com/arc2-group/servers.git /home/${username}/servers ||
      echo Pulling already cloned repo...
      cd /home/${username}/servers && ${pkgs.git}/bin/git pull
    '';
  };

  # Copy ssh key to ~/.ssh
  age.secrets.vm-admin-id.file = ./id_ed25519.age;
  system.activationScripts = {
    ssh-key.text = ''
      mkdir -p /home/${username}/.ssh
      cp ${config.age.secrets.vm-admin-id.path} /home/${username}/.ssh/id_ed25519
      ssh-keygen -y -f ${config.age.secrets.vm-admin-id.path} > /home/${username}/.ssh/id_ed25519.pub
      chown -R ${username}:users /home/${username}/.ssh
      chmod -R 700 /home/${username}/.ssh
    '';
  };
}
