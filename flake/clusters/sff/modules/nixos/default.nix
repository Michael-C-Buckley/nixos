_: {
  lupinix.clusters."sff".nixos.modules = {
    # keep-sorted start
    default = import ./_default.nix;
    filesystems = import ./filesystems.nix;
    hardware = import ./hardware.nix;
    network = import ./network;
    # keep-sorted end
  };
}
