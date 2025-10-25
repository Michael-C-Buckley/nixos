{config, ...}: {
  flake.modules.nixos.hjem-extended = {
    pkgs,
    lib,
    ...
  }: {
    imports = with config.flake.modules.nixos; [
      hjem-default
      hjem-cursor
      hjem-kitty
      hjem-ghostty
      hjem-zed
    ];

    hjem.users.michael = {
      gnupg.pinentryPackage = lib.mkForce pkgs.pinentry-qt;
      packages = with pkgs; [nvf];
    };
  };
}
