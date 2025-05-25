{self}: let
  inherit (self) inputs;
  # Build the configs for the hosts based on this function
  hostConfig = {
    host,
    system ? "x86_64-linux",
    modules ? [],
  }: let
    pkgs = import inputs.nixpkgs {
      inherit system;
    };
    lib = inputs.nixpkgs.lib;
    localOverlay = ../ovelays/localPkgs.nix;
    customLib = import ../lib {inherit pkgs lib;};
  in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit self customLib lib host system inputs localOverlay;};
      modules =
        [
          ./modules
          ./user/hjem.nix
        ]
        ++ modules;
    };

  mkMichaelConfig = {
    host,
    modules,
  }:
    hostConfig {
      inherit host;
      modules =
        [
          ./modules/presets/michael.nix
        ]
        ++ modules;
    };
  michaelhosts = ["x570" "t14" "p520" "wsl" "vm" "ssk"];
in
  builtins.listToAttrs (map (host: {
      name = host;
      value = mkMichaelConfig {
        inherit host;
        modules = [./hosts/${host}];
      };
    })
    michaelhosts)
  // {
    # T14 Minimal
    "t14-minimal" = hostConfig {
      host = "t14";
      modules = [./hosts/t14/minimal.nix];
    };
  }
