{
  self,
  inputs,
}:
let
  desktopModules = [
    ../modules/nixos/desktop.nix
  ];
  mkHost =
    {
      hostname,
      system ? "x86_64-linux",
      modules ? [ ],
    }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      specialArgs = { inherit self inputs; };
      modules = [
        ../hosts/${hostname}/config.nix
        { networking.hostName = hostname; }
      ]
      ++ modules;
    };
in
{
  x570 = mkHost {
    hostname = "x570";
    modules = desktopModules;
  };
  t14g5 = mkHost {
    hostname = "t14g5";
    modules = desktopModules;
  };
  b550 = mkHost {
    hostname = "b550";
    modules = [
      ../modules/nixos/server.nix
    ];
  };
}
