_: {
  lupinix.nixos.configurations = {
    "blade" = {
      system = "x86_64-linux";
      configuration = ./blade;
    };
    "o1" = {
      system = "aarch64-linux";
      configuration = ./o1;
    };
    "p520" = {
      system = "x86_64-linux";
      configuration = ./p520;
    };
    "sff" = {
      system = "x86_64-linux";
      configuration = ./sff;
    };
    "ssk" = {
      system = "x86_64-linux";
      configuration = ./ssk;
    };
    "t14" = {
      system = "x86_64-linux";
      configuration = ./t14;
    };
    "wsl" = {
      system = "x86_64-linux";
      configuration = ./wsl;
    };
    "x370" = {
      system = "x86_64-linux";
      configuration = ./x370;
    };
    "x570" = {
      system = "x86_64-linux";
      configuration = ./x570;
    };
  };
}
