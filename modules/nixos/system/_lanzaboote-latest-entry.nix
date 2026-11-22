# Shared by the NixOS and Finix Lanzaboote modules: a "latest" boot menu entry
# per installation, with that installation's generations sorted below it.
{
  lib,
  pkgs,
  namespace,
  title,
}:
let
  writer = pkgs.writeShellApplication {
    name = "lanzaboote-latest-entry";
    runtimeInputs = [ pkgs.coreutils ];
    text = builtins.readFile ./_lanzaboote-latest-entry.sh;
  };
in
{
  options = {
    enable = lib.mkEnableOption ''
      a systemd-boot entry that chainloads the current ${title} generation,
      with every individual generation sorted under the key `z${namespace}`
    '';

    title = lib.mkOption {
      type = lib.types.str;
      default = title;
      description = "Boot menu title of the latest-generation entry.";
    };

    sortKey = lib.mkOption {
      type = lib.types.str;
      default = "a${namespace}";
      description = "systemd-boot sort key of the latest-generation entry.";
    };
  };

  generationSortKey = cfg: if cfg.enable then "z${namespace}" else namespace;

  command =
    cfg: esp:
    "${lib.getExe writer} ${
      lib.escapeShellArgs [
        esp
        namespace
        cfg.title
        cfg.sortKey
      ]
    }";
}
