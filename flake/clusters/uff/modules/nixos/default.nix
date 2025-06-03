_: {
  lupinix.clusters."uff".nixos.modules = {
    # keep-sorted start
    _default = import ./__default.nix;
    corosync = import ./corosync.nix;
    default = import ./default.nix;
    filesystems = import ./filesystems.nix;
    hardware = import ./hardware.nix;
    network = import ./network;
    podman = import ./podman.nix;
    secrets = import ./secrets.nix;
    # keep-sorted end
  };
}
