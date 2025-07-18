_: {
  lupinix.clusters."uff".nixos.modules = {
    # keep-sorted start
    containers = import ./containers;
    corosync = import ./corosync.nix;
    default = import ./_default.nix;
    fileSystems = import ./filesystems.nix;
    hardware = import ./hardware.nix;
    network = import ./network;
    quadlet = import ./quadlet;
    secrets = import ./secrets.nix;
    # keep-sorted end
  };
}
