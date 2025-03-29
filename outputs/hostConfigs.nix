{inputs}: let
  # Build the configs for the hosts based on this function
  hostConfig = {host}:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs host;};
      modules = [
        ../default.nix
        ../hosts/${host}
        # inputs.michael-home.nixosModules.hjem.${host}
        inputs.vscode-server.nixosModules.default
      ];
    };

  hosts = [
    "x570"
    "t14"
    "p520"
  ];
  
in
  # Construct and return the attribute set
  builtins.listToAttrs (map (host: {
      name = host;
      value = hostConfig {inherit host;};
    })
    hosts)
