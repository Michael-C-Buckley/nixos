# Declared datasets, which includes other distros I run as well since Disko is good at
# formatting the drives to start with and disko-zfs helps too
{flake, ...}: let
  z = flake.lib.disko.mkDataset;
  chimera = "/var/lib/machines/chimera";
  # gentoo = "/var/lib/machines/gentoo";
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
      compression = "zstd:6";
    };
  };
  "nixos/nix" = z {
    options = {
      recordsize = "32K";
      compression = "zstd:2";
    };
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

  # Chimera Linux
  # It's another distro I have installed, but mounted here so it can be run
  # as a systemd-nspawn for convenience
  chimera = z {
    options.mountpoint = "none";
  };

  "chimera/system" = z {
    options.mountpoint = "none";
  };
  "chimera/system/usr" = z {
    mountpoint = "${chimera}/usr";
    options.recordsize = "16K";
  };
  "chimera/system/etc" = z {
    mountpoint = "${chimera}/etc";
    options.recordsize = "4K";
  };

  "chimera/home" = z {
    mountpoint = "${chimera}/home";
  };
  "chimera/var" = z {
    mountpoint = "${chimera}/var";
  };
  "chimera/var/lib" = z {
    mountpoint = "${chimera}/var/lib";
  };
  "chimera/var/log" = z {
    mountpoint = "${chimera}/var/log";
    options = {
      recordsize = "1M";
      compression = "zstd";
    };
  };
  "chimera/nix" = z {
    mountpoint = "${chimera}/nix";
    options = {
      recordsize = "32K";
      compression = "zstd:2";
    };
  };
  "chimera/root" = z {
    mountpoint = "${chimera}";
  };

  gentoo =
    z {
    };

  "gentoo/root" = z {
    # mountpoint = "${gentoo}";
  };

  "gentoo/nix" = z {
    # mountpoint = "${gentoo}/nix";
    options = {
      recordsize = "32K";
      compression = "zstd";
    };
  };

  "gentoo/home" = z {
    # mountpoint = "${gentoo}/home";
  };

  "gentoo/var" = z {
    # mountpoint = "${gentoo}/var";
  };

  "gentoo/var/log" = z {
    # mountpoint = "${gentoo}/var/log";
    options = {
      recordsize = "1M";
      compression = "zstd";
    };
  };

  "gentoo/var/cache" = z {
    # mountpoint = "${gentoo}/var/lib";
    options.compression = "zstd";
  };

  "gentoo/var/tmp" = z {
    # mountpoint = "${gentoo}/var/tmp";
    options.compression = "zstd";
  };
}
