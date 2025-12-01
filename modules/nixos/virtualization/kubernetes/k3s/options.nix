{
  flake.modules.nixos.k3s = {lib, ...}: {
    options.custom.k3s.impermanence = {
      use_persist = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Use default persist settings when not using other filesystems";
      };
      use_cache = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Use default cache settings when not using other filesystems";
      };
    };
  };
}
