_: {
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1b07fc27-ad90-43d2-925d-24d6b8218eb6";
    fsType = "ext4";
  };

  fileSystems."/local/llm" = {
    device = "/dev/disk/by-uuid/f0ec224a-7782-4746-859c-8a62e6cfb77a";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B34E-A49B";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };
}
