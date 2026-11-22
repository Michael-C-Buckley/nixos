{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.direnv;
  format = pkgs.formats.toml { };
in
{
  options.programs.direnv = {
    enable = lib.mkEnableOption "direnv";
    package = lib.mkPackageOption pkgs "direnv" { };
    silent = lib.mkEnableOption "silent direnv logging";
    settings = lib.mkOption {
      inherit (format) type;
      default = { };
      description = "Settings for direnv.toml. The shared Zsh config supplies the shell hook.";
    };
    nix-direnv = {
      enable = lib.mkEnableOption "nix-direnv";
      package = lib.mkPackageOption pkgs "nix-direnv" { };
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [ cfg.package ] ++ lib.optional cfg.nix-direnv.enable cfg.nix-direnv.package;
    programs.direnv.settings.global = lib.mkIf cfg.silent {
      log_format = "-";
      log_filter = "^$";
    };
    xdg.config.files = {
      "direnv/direnv.toml".source = format.generate "direnv.toml" cfg.settings;
      "direnv/lib/hjem-nix-direnv.sh" = lib.mkIf cfg.nix-direnv.enable {
        source = "${cfg.nix-direnv.package}/share/nix-direnv/direnvrc";
      };
    };
  };
}
