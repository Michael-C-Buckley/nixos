# Hjem options meant to be consumed within this flake
{
  flake.hjemModules.localOptions = {
    config,
    pkgs,
    lib,
    ...
  }: {
    options = {
      sops.age.defaultKey = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "The default age key at `~/.config/sops/age/keys.text`";
      };
      git.signingKey = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "The default signing key for git commits";
      };
    };

    config = {
      files.".config/sops/age/keys.txt" = lib.mkIf (config.sops.age.defaultKey != null) {
        source = pkgs.writeText "sops-age-key" config.sops.age.defaultKey;
      };
    };
  };
}
