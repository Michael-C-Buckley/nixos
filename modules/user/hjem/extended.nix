{config, ...}: {
  flake.modules.nixos.hjem-extended = {
    pkgs,
    lib,
    ...
  }: {
    imports = with config.flake.modules.nixos; [
      hjem-default
      hjem-cursor
      hjem-helix
      hjem-gpgAgent
      hjem-kitty
      hjem-ghostty
      hjem-zed
    ];

    hjem.users.michael = {
      gnupg.pinentryPackage = lib.mkForce pkgs.pinentry-qt;

      environment.sessionVariables = {
        BROWSER = "helium";
        NIXOS_OZONE_WL = "1";
        GTK_USE_PORTAL = "1";
      };
    };
  };
}
