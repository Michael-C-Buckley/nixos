let
  # Reduce duplication
  z = attrs:
    {
      type = "zfs_fs";
      options.mountpoint = "legacy";
    }
    // attrs;
in {
  nixos = z {
    options.mountpoint = "none";
  };
  "nixos/home" = z {
    mountpoint = "/home";
  };
  "nixos/var" = z {
    mountpoint = "/var";
  };
  "nixos/var/lib" = z {
    mountpoint = "/var/lib";
  };
  "nixos/var/log" = z {
    mountpoint = "/var/log";
    options = {
      recordsize = "1M";
      compression = "zstd";
    };
  };
  "nixos/nix" = z {
    options.recordsize = "32K";
  };
  "nixos/root" = z {
    mountpoint = "/";
  };

  games = z {
    options.recordsize = "1M";
    mountpoint = "/media/games";
  };

  # This will container the various "normal" home directories that are shared
  # among distros but without various state folders, via binds
  michael = z {
    mountpoint = "/media/michael";
  };
}
