{self}: let
  inherit (self) inputs;
  # Build the configs for the hosts based on this function
  hostConfig = {
    host,
    system ? "x86_64-linux",
    extraModules ? [],
  }: let
    pkgs = import inputs.nixpkgs {
      inherit system;
    };
    lib = inputs.nixpkgs.lib;
    customLib = import ../lib {inherit pkgs lib;};
  in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit self customLib lib host system inputs;};
      modules =
        [
          ./modules
          ./hosts/${host}
          ./user/hjem.nix
        ]
        ++ extraModules;
    };

  mkMichaelConfig = {host}:
    hostConfig {
      inherit host;
      extraModules = [
        ./modules/presets/michael.nix
      ];
    };
  michaelhosts = ["x570" "t14" "p520" "wsl" "vm"];
in
  builtins.listToAttrs (map (host: {
      name = host;
      value = mkMichaelConfig {inherit host;};
    })
    michaelhosts)
