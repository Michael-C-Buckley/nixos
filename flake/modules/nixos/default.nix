_: {
  lupinix.nixos.modules = {
    # keep-sorted start
    graphical = import ./graphical;
    hardware = import ./hardware;
    network = import ./network;
    nix = import ./nix;
    packageSets = import ./packageSets;
    packages = import ./packages;
    presets = import ./presets;
    programs = import ./programs;
    security = import ./security;
    storage = import ./storage;
    system = import ./system;
    virtualization = import ./virtualization;
    # keep-sorted end
  };
}
