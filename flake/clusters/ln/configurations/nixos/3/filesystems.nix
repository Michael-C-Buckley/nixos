_: let
  mkZFS = path: {
    device = "zroot/ln3/${path}";
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  system = {
    zfs.enable = true;
    impermanence.enable = true;
  };

  fileSystems = {
    # "/" = mkZFS "root";
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=1G"
        "mode=755"
      ];
    };

    "/nix" = mkZFS "nix";
    "/cache" = mkZFS "cache";
    "/persist" = mkZFS "persist";

    # Users
    "/home/michael" = mkZFS "home/michael";
    "/home/shawn" = mkZFS "home/shawn";

    # Var
    "/var/lib/kubernetes" = mkZFS "var/kube";
  };
}
