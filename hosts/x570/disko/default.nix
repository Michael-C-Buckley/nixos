# I have split the disko config into several files as it's extremely
# verbose and nested if kept together, which is just hard to read
{flake, ...}: {
  disko = {
    zfs.enable = true;
    devices = {
      disk = import ./_disks.nix {inherit flake;};
      lvm_vg = import ./_lvm.nix;
      zpool.zroot = flake.lib.disko.mkZroot (import ./_datasets.nix {inherit flake;});
    };
  };
}
