{
  flake.modules.nixos.t14 = {
    hjem.users.michael = {
      files = {
        ".config/sops/age/keys.txt".text = "AGE-PLUGIN-YUBIKEY-132ES2Q5ZH30TJPCGVD8VF";
      };
      rum.programs = {
        git.settings.user.signingkey = "6D3100F97A6F138623E1A1D55EE007B4E468FB39!";
        ghostty.settings.background-opacity = "0.7";
      };
    };
  };
}
