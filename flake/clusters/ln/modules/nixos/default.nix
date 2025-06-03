_: {
  lupinix.clusters."ln".nixos.modules = {
    # keep-sorted start
    _default = import ./__default.nix;
    default = import ./_default.nix;
    fileSystems = import ./filesystems.nix;
    hardware = import ./hardware.nix;
    kubernetes = import ./kubernetes;
    networking = import ./networking;
    # keep-sorted end
  };
}
