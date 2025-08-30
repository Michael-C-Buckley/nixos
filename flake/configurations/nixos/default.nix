_: {
  lupinix.nixos.configurations = {
    "o1" = {
      system = "aarch64-linux";
      configuration = ./o1;
    };
    "p520" = {
      system = "x86_64-linux";
      configuration = ./p520;
    };
    "ssk" = {
      system = "x86_64-linux";
      configuration = ./ssk;
    };
    "t14" = {
      system = "x86_64-linux";
      configuration = ./t14;
    };
    "x570" = {
      system = "x86_64-linux";
      configuration = ./x570;
    };
  };
}
