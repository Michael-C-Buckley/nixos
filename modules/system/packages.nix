{config, ...}: {
  flake.modules.systemManager.packages = {pkgs, ...}: {
    environment.systemPackages = [
      (pkgs.callPackage "${config.flake.npins.system-manager}/package.nix" {})
    ];
  };
}
