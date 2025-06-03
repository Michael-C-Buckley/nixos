_: {
  lupinix.clusters."oracle".nixos.modules = {
    # keep-sorted start
    _default = import ./__default.nix;
    default = import ./_default.nix;
    #disko = import ./disko.nix;
    networking = import ./networking.nix;
    # keep-sorted end
  };
}
