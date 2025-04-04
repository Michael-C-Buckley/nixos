{
  customLib,
  inputs,
}: let
  # Build the configs for the hosts based on this function
  clusterConfig = {
    cluster,
    host,
  }: let
    system =
      if host == "o1"
      then "aarch64-linux"
      else "x86_64-linux";
  in
    inputs.nixpkgs.lib.nixosSystem {
      # Oracle1 is an exception as it is an ARM host
      inherit system;
      specialArgs = {inherit customLib host system inputs;};
      modules = [
        ../base.nix
        ../clusters/${cluster}
        ../clusters/${cluster}/hosts/${host}
      ];
    };

  generateCluster = {
    cluster,
    hostPrefix,
    max,
  }:
    builtins.listToAttrs (
      builtins.genList (
        i: let
          number = i + 1;
          host = "${hostPrefix}${toString number}";
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
    hostPrefix = "uff";
    max = 3;
  }
  // generateCluster {
    cluster = "oracle";
    hostPrefix = "o";
    max = 2;
  }
  // generateCluster {
    cluster = "ln";
    hostPrefix = "ln";
    max = 3;
  }
