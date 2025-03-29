{inputs}: let
  # Build the configs for the hosts based on this function
  clusterConfig = {
    cluster,
    host,
  }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs host;};
      modules = [
        inputs.vscode-server.nixosModules.default
        ../base.nix
        ../clusters/${cluster}
        ../clusters/${cluster}/hosts/${host}
        ../home/hjem.nix
      ];
    };

  generateCluster = {
    cluster,
    max,
  }:
    builtins.listToAttrs (
      builtins.genList (
        i: let
          number = i + 1;
          host = "${cluster}${toString number}";
        in {
          name = host;
          value = clusterConfig {inherit cluster host;};
        }
      )
      max
    );
in
  generateCluster {
    cluster = "uff";
    max = 3;
  }
