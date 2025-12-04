{config, ...}: let
  inherit (config.flake.modules) nixos;
in {
  flake.modules.nixos.o1 = {lib, ...}: {
    imports = with nixos; [
      cloudPreset
      k3s
      netbird
    ];
    environment = {
      # This is not linking for some reason, attempting to force copy instead of link
      etc."nix/nix.conf".mode = lib.mkForce "0755";
    };

    #  It's a 4 vCPU server, don't overload it
    nix.settings = {
      cores = 2;
      max-jobs = 2;
    };

    system = {
      stateVersion = "25.11";
    };
  };
}
