{
  customLib,
  inputs,
}: let
  # Build the configs for the hosts based on this function
  clusterConfig = {
    cluster,
    host,
  }: let system = if host == "oracle1" then "aarch64-linux" else "x86_64-linux"; in
    inputs.nixpkgs.lib.nixosSystem {
      # Oracle1 is an exception as it is an ARM host
      inherit system;
      specialArgs = {inherit customLib host system inputs;};
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
  } //
  generateCluster {
    cluster = "oracle";
    max = 2;
  }
