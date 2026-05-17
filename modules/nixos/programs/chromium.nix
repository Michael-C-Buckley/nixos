{
  flake.modules.nixos.chromiumPolicies = {
    programs.chromium = {
      enable = true; # merely enables policies, does not install anything
      extraOpts = {
        PasswordManagerEnabled = false;
        SpellcheckEnabled = true;
        SpellcheckLanguage = ["en-US"];
      };
    };
  };
}
