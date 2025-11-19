{
  flake.modules.nixos.pam-yubikey = {pkgs, ...}: {
    custom.impermanence.persist.user.directories = [
      ".config/Yubico"
    ];
    environment.systemPackages = [pkgs.pam_u2f];
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
