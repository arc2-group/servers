_: {
  nix.settings = {
    substituters = [
      "https://arc2-group.cachix.org"
      "https://attic.kennel.juneis.dog/conduwuit"
    ];
    trusted-public-keys = [
      "arc2-group.cachix.org-1:SfZ4Amg/VroYhmCRNX0mQcFEWGCFWvn31s3gwEaU/2U="
      "conduwuit:BbycGUgTISsltcmH0qNjFR9dbrQNYgdIAcmViSGoVTE="
    ];
  };
}
