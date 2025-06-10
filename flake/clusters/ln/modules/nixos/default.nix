_: {
  lupinix.clusters."ln".nixos.modules = {
    # keep-sorted start
    default = import ./_default.nix;
    fileSystems = import ./filesystems.nix;
    hardware = import ./hardware.nix;
    kubernetes = import ./kubernetes;
    networking = import ./networking;
    # keep-sorted end
  };
}
