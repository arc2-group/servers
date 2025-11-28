_: {
  networking.hosts = {
    "fd5e:934f:acab:1::6001" = [ "vm-admin" ];
    "fd5e:934f:acab:1::6002" = [ "vm-public-media" ];
    "fd5e:934f:acab:1::6003" = [ "vm-public-ingress" ];
    "fd5e:934f:acab:1::6004" = [ "vm-public-cloud" ];
    "fd5e:934f:acab:1::6005" = [ "vm-public-matrix" ];
    "fd5e:934f:acab:1::6006" = [ "vm-monitoring" ];
    "fd5e:934f:acab:1::6007" = [ "vm-public-qrp" ];
    "fd5e:934f:acab:1::6009" = [ "vm-public-qminecraft" ];

    "fd5e:934f:acab:2::8001" = [ "ext-ltvg" ];
  };
}
