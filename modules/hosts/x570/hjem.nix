{
  flake.modules.nixos.x570 = {
    hjem.users.michael = {
      sops.age.defaultKey = "AGE-PLUGIN-YUBIKEY-1A64Q2Q5ZRRP4GDQ2A95S8";
      git.signingKey = "408634D7706AC8085CD41AFFC36327B33A6765A7!";
    };
  };
}
