{self}: let
  inherit (self) inputs;
  # All current individual hosts are currently X86
  system = "x86_64-linux";
  # Build the configs for the hosts based on this function
  hostConfig = {host}: let
    pkgs = import inputs.nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
    };
    lib = inputs.nixpkgs.lib;
    customLib = import ../lib {inherit pkgs lib;};
  in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit self pkgs customLib lib host system inputs;};
      modules = [
        ../base.nix
        ../hosts/${host}
      ];
    };

  hosts = [
    "x570"
    "t14"
    "p520"
    "wsl"
    "vm"
  ];
in
  # Construct and return the attribute set
  builtins.listToAttrs (map (host: {
      name = host;
      value = hostConfig {inherit host;};
    })
    hosts)
