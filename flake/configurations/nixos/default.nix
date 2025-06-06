_: {
  lupinix.nixos.configurations = {
    "p520" = {
      system = "x86_64-linux";
      configuration = ./p520;
    };
    "ssk" = {
      system = "x86_64-linux";
      configuration = ./ssk;
    };
    "t14-minimal" = {
      system = "x86_64-linux";
      configuration = ./t14/minimal.nix;
    };
    "t14" = {
      system = "x86_64-linux";
      configuration = ./t14;
    };
    "vm" = {
      system = "x86_64-linux";
      configuration = ./vm;
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
