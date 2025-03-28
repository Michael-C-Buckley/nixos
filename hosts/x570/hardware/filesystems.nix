{ ... }: let
  createBind = name: {
    "/home/michael/${name}" = {
      device = "/media/home/michael/${name}";
      fsType = "none";
      options = ["bind"];
    };
  };

  bindDirectories = [
    "Documents"
    "Downloads"
    "Pictures"
    "Videos"
    "Music"
    "Projects"
  ];

  bindMounts = builtins.foldl' (acc: dir: acc // createBind dir) {} bindDirectories;

in {
  fileSystems = bindMounts // {
    "/" = {
      device = "/dev/disk/by-uuid/aa507166-a2af-4955-af78-cfbcb87f6ca1";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/C75D-B86A";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
    "/nix/store" = {
      device = "/dev/disk/by-uuid/9ce98309-3f39-46f2-bb4e-7cd8883d6cf6";
      fsType = "ext4";
    };
    "var/lib" = {
      device = "/dev/disk/by-uuid/b08d3443-bd7e-41e2-bfc5-e6c86b89815e";
      fsType = "ext4";
    };
    "/media/games" = {
      device = "/dev/disk/by-uuid/6a856321-1977-4793-9fc5-dd113680caed";
      fsType = "ext4";
    };
    "/media/home" = {
      device = "/dev/disk/by-uuid/560ef33a-7698-4828-9b46-58004cc4af0a";
      fsType = "ext4";
    };
  };
}
