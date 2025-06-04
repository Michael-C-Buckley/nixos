_: {
  lupinix.clusters."sff".nixos.modules = {
    # keep-sorted start
    default = import ./_default.nix;
    hardware = import ./hardware.nix;
    network = import ./network;
    # keep-sorted end
  };
}
