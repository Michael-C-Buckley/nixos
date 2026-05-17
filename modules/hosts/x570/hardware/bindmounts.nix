# Bindmounts for various components of my system
#  - ext4 cache directory for small metadata files that ZFS is underoptimized for
#  - Binding out the home directories to prevent multi-distro home clashing
let
  b = attrs:
    {
      fsType = "none";
      options = ["bind" "noatime" "x-gvfs-hide"];
    }
    // attrs;
  c = "/media/cache";
  m = "/media/michael";

  userDirs = ["Documents" "Pictures" "Projects" "Videos" "Downloads"];
in {
  flake.modules.nixos.x570 = {
    # Ensure the folders exist
    systemd.tmpfiles.rules =
      [
        "d ${c}/nixos/nix/var 0755 root root -"
        "d ${c}/var/tmp 0755 root root -"
        "d ${c}/michael/cache 0755 michael users -"
        "d ${c}/michael/shaders/steam 0755 michael users -"
        "d ${c}/michael/shaders/vulkan 0755 michael users -"
      ]
      ++ (map (a: "d /home/michael/${a} 0755 michael users -") userDirs);
    fileSystems =
      {
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
        "/home/michael/Documents" = b {
          device = "${m}/Documents";
        };
      }
      // builtins.listToAttrs (map (
          a: {
            name = "/home/michael/${a}";
            value = b {device = "${m}/${a}";};
          }
        )
        userDirs);
  };
}
