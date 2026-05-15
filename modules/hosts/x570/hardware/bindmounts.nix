# Bind out various directories that are less ideal when on CoW such as ZFS
# to an ext4 partition
# This is not critical but a minor/moderate optimization
let
  b = attrs:
    {
      fsType = "none";
      options = ["bind" "noatime" "x-gvfs-hide"];
    }
    // attrs;
  c = "/media/cache";
in {
  flake.modules.nixos.x570 = {
    # Ensure the folders exist
    systemd.tmpfiles.rules = [
      "d ${c}/nixos/nix/var 0755 root root -"
      "d ${c}/var/tmp 0755 root root -"
      "d ${c}/michael/cache 0755 michael users -"
      "d ${c}/michael/shaders/steam 0755 michael users -"
      "d ${c}/michael/shaders/vulkan 077 michael users -"
    ];
    fileSystems = {
      "/nix/var" = b {
        device = "${c}/nixos/nix/var";
      };
      "/var/tmp" = b {
        device = "${c}/var/tmp";
      };
      "/home/michael/.cache" = b {
        device = "${c}/michael/cache";
      };
      "/home/michael/.local/share/Steam/steamapps/shadercache" = b {
        device = "${c}/michael/shaders/steam";
      };
      "/home/michael/.local/share/vulkan/shader_cache" = b {
        device = "${c}/michael/shaders/vulkan";
      };
    };
  };
}
