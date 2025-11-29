{
  flake.modules.nixos.pam-yubikey = {pkgs, ...}: {
    environment.systemPackages = [pkgs.pam_u2f];
    security.pam = {
      services.sudo.u2fAuth = true;
      u2f = {
        enable = true;
        control = "sufficient";
        settings = {
          # Any host using it will have their secrets here
          authfile = "/run/secrets/pam_u2f_auth";
          cue = true;
        };
      };
    };
  };
}
