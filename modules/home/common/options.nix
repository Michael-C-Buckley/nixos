{
  flake.modules.homeManager.default = {lib, ...}: {
    custom.systemd.use = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether or not systemd is used by the instance and features should be included";
    };
  };
}
