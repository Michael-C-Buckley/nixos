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
    "t14" = {
      system = "x86_64-linux";
      configuration = ./t14;
    };
    "x570" = {
      system = "x86_64-linux";
      configuration = ./x570;
    };

    # Currently Unused Systems
    # "ssk" = {
    #   system = "x86_64-linux";
    #   configuration = ./ssk;
    # };
    # "x370" = {
    #   system = "x86_64-linux";
    #   configuration = ./x370;
    # };
    # "sff" = {
    #   system = "x86_64-linux";
    #   configuration = ./sff;
    # };
    # "blade" = {
    #   system = "x86_64-linux";
    #   configuration = ./blade;
    # };
  };
}
