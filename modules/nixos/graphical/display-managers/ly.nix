# WIP module, set for overhaul with the NixOS module supporting autologin gets merged
{
  flake.modules.nixos.ly = {
    config,
    lib,
    ...
  }: {
    # copied from ly repo, using absolute path to pam_systemd.so or it would error
    security.pam.services.ly-autologin = {
      text = ''
        auth       required     pam_permit.so
        -auth      optional     pam_gnome_keyring.so
        -auth      optional     pam_kwallet5.so

        account    include      login

        password   include      login
        -password  optional     pam_gnome_keyring.so use_authtok

        -session   optional     ${config.systemd.package}/lib/security/pam_systemd.so       class=greeter
        -session   optional     pam_elogind.so
        session    include      login
        -session   optional     pam_gnome_keyring.so auto_start
        -session   optional     pam_kwallet5.so      auto_start
      '';
    };
    services = {
      greetd.enable = false; # Intentionally collide in case both are enabled

      displayManager.ly = {
        enable = true;
        settings = {
          bigclock = "en";
          auto_login_service = "ly-autologin";
          auto_login_session = lib.mkDefault "niri-wrapped";
          auto_login_user = lib.mkDefault "michael";
        };
      };
    };
  };
}
