_: {
  lupinix.clusters."oracle".nixos.configurations = {
    "1" = {
      system = "aarch64-linux";
      configuration = ./1;
    };
    "2" = {
      system = "x86_64-linux";
      configuration = ./2;
    };
    "3" = {
      system = "x86_64-linux";
      configuration = ./3;
    };
  };
}
