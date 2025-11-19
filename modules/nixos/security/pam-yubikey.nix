{
  flake.modules.nixos.pam-yubikey = {
    custom.impermanence.persist.user.directories = [
      ".config/Yubico"
    ];
    security.pam = {
      services.sudo.u2fAuth = true;
      u2f = {
        enable = true;
        control = "sufficient";
        settings = {
          cue = true;
          interactive = true;
        };
      };
    };
  };
}
