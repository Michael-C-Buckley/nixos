# This is the same as WSL but with Btrfs
_: let
  mkBtrfs = vol: {
    device = "/dev/disk/by-uuid/e0b199ac-5b2d-42f3-90fc-70bf8083d2d3";
    fsType = "btrfs";
    options = ["subvol=@${vol}" "compress=zstd" "noatime"];
  };
in {
  # Use everything else WSL already has
  imports = [./default.nix];

  # Include these filesystems
  fileSystems = {
    "/nix" = mkBtrfs "nix";
    "/cache" = mkBtrfs "cache";
    "/persist" = mkBtrfs "persist";
    "/tmp" = mkBtrfs "tmp";
  };

  system.impermanence.enable = true;
}
