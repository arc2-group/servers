{ inputs, ... }:
{
  # https://github.com/NixOS/nixpkgs/pull/420722
  disabledModules = [
    "services/matrix/mautrix-whatsapp.nix"
  ];
  imports = [
    "${inputs.nixpkgs_unstable}/nixos/modules/services/matrix/mautrix-whatsapp.nix"
  ];

  services.mautrix-whatsapp = {
    enable = true;
    registerToSynapse = false;
    settings = {
      homeserver = {
        domain = "blazma.st";
        address = "http://[::1]:6167";
      };
      appservice = {
        id = "whatsapp";
      };
      matrix = {
        delivery_receipts = true;
      };
      backfill = {
        enable = true;
      };
      encryption = {
        allow = true;
        default = true;
        delete_keys = {
          dont_store_outbound = true;
          ratchet_on_decrypt = true;
          delete_fully_used_on_decrypt = true;
          delete_prev_on_new_session = true;
          delete_on_device_delete = true;
          periodically_delete_expired = true;
        };
        verification_levels = {
          receive = "cross-signed-tofu";
          send = "cross-signed-tofu";
          share = "cross-signed-tofu";
        };
        pickle_key = "maunium.net/go/mautrix-whatsapp";
      };
      network = {
        history_sync = {
          max_initial_conversations = 10;
        };
      };
      bridge = {
        permissions = {
          "*" = "relay";
          "blazma.st" = "user";
          "@naides3:blazma.st" = "admin";
          "@spur:blazma.st" = "admin";
        };
      };
    };

    serviceDependencies = [ "continuwuity.service" ];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];
}
