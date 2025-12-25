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

      modules = with nixos;
        [
          uff
          serverPreset
          dnscrypt-proxy
          ntp
        ]
        ++ [nixos.${hostname}];

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
in {
  flake.nixosConfigurations = builtins.listToAttrs (map (name: {
      inherit name;
      value = mkSystem name;
    })
    ["uff1" "uff2" "uff3"]);
}
