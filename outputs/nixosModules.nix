_: {
  # Expose a Hjem output for anywhere I'd want to use it
  hjem = {
    default = {...}: {imports = [./home/hjem.nix];};
  };
}
