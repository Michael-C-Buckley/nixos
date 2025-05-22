_: {
  # Expose a Hjem output for anywhere I'd want to use it
  hjemConfig = {
    default = {...}: {imports = [../configurations/home/hjem.nix];};
  };

  packageSets = {...}: {imports = [./nixos/packageSets];};
}
