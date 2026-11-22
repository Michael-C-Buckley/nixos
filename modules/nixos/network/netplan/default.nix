{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.networking.netplan;
  json = pkgs.formats.json { };
  generated = lib.mapAttrs (
    name: configuration: pkgs.callPackage ./package.nix { inherit name configuration; }
  ) cfg.configurations;
in
{
  options.networking.netplan.configurations = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf json.type);
    default = { };
    description = ''
      Netplan documents expressed as Nix attributes, keyed by .yaml filename.
      Files are serialized as JSON, linted with yamllint, and checked for
      malformed MAC and IP addresses before installation under /etc/netplan.
    '';
  };

  config = lib.mkIf (cfg.configurations != { }) {
    networking.netplan.enable = lib.mkDefault true;

    assertions = lib.concatLists (
      lib.mapAttrsToList (name: _: [
        {
          assertion = builtins.match "[a-zA-Z0-9][a-zA-Z0-9._-]*\\.yaml" name != null;
          message = "Netplan configuration filename '${name}' must be a plain .yaml filename.";
        }
        {
          assertion = !(builtins.hasAttr name cfg.configFiles);
          message = "Netplan configuration '${name}' is defined in both configurations and configFiles.";
        }
      ]) cfg.configurations
    );

    environment.etc = lib.mapAttrs' (name: source: {
      name = "netplan/${name}";
      value = {
        inherit source;
        mode = "0600";
      };
    }) generated;

    system.build.netplan = pkgs.linkFarm "netplan-configs" (
      lib.mapAttrsToList (name: path: { inherit name path; }) generated
    );
  };
}
