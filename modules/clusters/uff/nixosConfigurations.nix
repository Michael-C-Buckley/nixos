{
  config,
  inputs,
  ...
}: let
  inherit (inputs) nixpkgs;
  inherit (config.flake.modules) nixos;

  # These hosts are all X86
  system = "x86_64-linux";

  mkSystem = hostname:
    nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        config.flake.modules.nixos.${hostname}
        nixos.uff
        nixos.serverPreset
        nixos.dnscrypt-proxy
      ];

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
in {
  flake.nixosConfigurations = {
    uff1 = mkSystem "uff1";
    uff2 = mkSystem "uff2";
    uff3 = mkSystem "uff3";
  };
}
