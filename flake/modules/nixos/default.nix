_: {
  lupinix.nixos.modules = {
    # keep-sorted start
    graphical = import ./graphical;
    hardware = import ./hardware;
    network = import ./network;
    packageSets = import ./packageSets;
    packages = import ./packages;
    presets = import ./presets;
    programs = import ./programs;
    security = import ./security;
    services = import ./services;
    storage = import ./storage;
    system = import ./system;
    virtualization = import ./virtualization;
    # keep-sorted end

    # Blame your hjem/home/user Chimera.
    user-hjem = import ./user/hjem.nix; # hjem
    # user-home = import ./user/home.nix; # home-manager
  };
}
