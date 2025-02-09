_: {
  nix.settings = {
    substituters = [
      "https://arc2-group.cachix.org"
      "https://attic.kennel.juneis.dog/conduwuit"
      "https://attic.kennel.juneis.dog/conduit"
      "https://conduwuit.cachix.org"
    ];
    trusted-public-keys = [
      "arc2-group.cachix.org-1:SfZ4Amg/VroYhmCRNX0mQcFEWGCFWvn31s3gwEaU/2U="
      "conduwuit:BbycGUgTISsltcmH0qNjFR9dbrQNYgdIAcmViSGoVTE="
      "conduit:eEKoUwlQGDdYmAI/Q/0slVlegqh/QmAvQd7HBSm21Wk="
      "conduwuit.cachix.org-1:MFRm6jcnfTf0jSAbmvLfhO3KBMt4px+1xaereWXp8Xg="
    ];
  };
}
