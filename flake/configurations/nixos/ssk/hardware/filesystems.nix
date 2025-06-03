_: let
  zfsFs = name: {
    device = "ZROOT/nixos/${name}";
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  system.boot.uuid = "3A0E-2554";

  # Preserve everything for root
  environment.persistence."/persist".directories = ["/root"];

  fileSystems = {
    # Tmpfs
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=2G"
        "mode=755"
      ];
    };
    "/tmp" = zfsFs "tmp";
    "/nix" = zfsFs "nix";
    "/cache" = zfsFs "cache";
    "/persist" = zfsFs "persist";
  };
}
