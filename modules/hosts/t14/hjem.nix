{
  flake.modules.nixos.t14 = {
    hjem.users.michael = {
      sops.age.defaultKey = "AGE-PLUGIN-YUBIKEY-132ES2Q5ZH30TJPCGVD8VF";
      git.signingKey = "6D3100F97A6F138623E1A1D55EE007B4E468FB39!";
    };
  };
}
