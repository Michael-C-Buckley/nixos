{inputs, ...}: {
  flake.nixosModules.hjem-extended = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = [
      inputs.self.nixosModules.hjem-default
      inputs.self.modules.nixos.hjem-cursor
      ../modules/vscodium/_default.nix
    ];

    users.users.michael.packages = [(lib.hiPrio inputs.self.packages.${config.nixpkgs.system}.nvf)];

    hjem.users.michael.gnupg.pinentryPackage = lib.mkForce pkgs.pinentry-qt;
  };
}
