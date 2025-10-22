{inputs, ...}: {
  flake.modules.nixos.hjem-extended = {
    pkgs,
    lib,
    ...
  }: {
    imports = with inputs.self.modules.nixos; [
      hjem-default
      hjem-cursor
      hjem-kitty
      hjem-ghostty
    ];

    hjem.users.michael = {
      gnupg.pinentryPackage = lib.mkForce pkgs.pinentry-qt;
      packages = [(lib.hiPrio inputs.self.packages.${pkgs.system}.nvf)];
    };
  };
}
