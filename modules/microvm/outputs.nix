{
  config,
  inputs,
  ...
}: let
  system = "x86_64-linux";
in {
  flake = {
    packages.${system}.devbox = config.flake.nixosConfigurations.devbox.config.microvm.declaredRunner;
    nixosConfigurations = {
      devbox = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [config.flake.modules.nixos.devbox];
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      };
    };
  };
}
