{
  flake.modules.nixos.chromiumPolicies = {
    programs.chromium = {
      enable = true; # merely enables policies, does not install anything
      extensions = [
        "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Darkreader
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
        "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
        "chphlpgkkbolifaimnlloiipkdnihall" # OneTab
      ];
      extraOpts = {
        PasswordManagerEnabled = false;
        SpellcheckEnabled = true;
        SpellcheckLanguage = ["en-US"];
      };
    };
  };
}
