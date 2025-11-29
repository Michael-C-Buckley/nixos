{
  flake.modules.nixos.pam-yubikey = {
    config,
    pkgs,
    ...
  }: {
    environment.systemPackages = [pkgs.pam_u2f];
    security.pam = {
      services.sudo.u2fAuth = true;
      u2f = {
        enable = true;
        control = "sufficient";
        settings = {
          authfile = config.sops.secrets.pam_u2f_auth.path;
          cue = true;
        };
      };
    };
  };
}
