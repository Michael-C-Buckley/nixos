{
  flake.modules.homeManager.default = {
    config,
    lib,
    pkgs,
    ...
  }: {
    custom.smfh.manifest = pkgs.writeText "smfh-manifest.json" (builtins.toJSON (
      lib.mapAttrsToList (
        name: file:
          lib.filterAttrs (_: v: v != null) {
            inherit name;
            inherit (file) type source target permissions uid gid clobber;
          }
      )
      config.custom.files
    ));
  };
}
