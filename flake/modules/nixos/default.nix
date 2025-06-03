_: {
  lupinix.nixos.modules = {
    # keep-sorted start
    gaming = import ./gaming.nix;
    graphical = import ./graphical;
    network = import ./network;
    packageSets = import ./packageSets;
    packages = import ./packages;
    presets-michael = import ./presets/michael.nix;
    presets-nvidia = import ./presets/nvidia.nix;
    programs = import ./programs;
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
