# HIGHLY EXPERIMENTAL
# This takes and adapts fish to work when sourced from nixpkgs
# There are major caveats as some features assumed to exist in NixOS
# are not present in system-manager
{inputs, ...}: {
  flake.modules.systemManager.fish = {lib, ...}: let
    mkLines = description:
      lib.mkOption {
        inherit description;
        type = lib.types.lines;
        default = '''';
      };
  in {
    imports = [
      (import "${inputs.nixpkgs}/nixos/modules/programs/fish.nix")
    ];

    options = {
      documentation.man.generateCaches = lib.mkOption {
        description = "Patched option for generating fish documentation";
        type = lib.types.bool;
        default = true;
      };
      environment = {
        shells = lib.mkOption {
          description = "Shells shim.";
          type = lib.types.listOf lib.types.str;
          default = [];
        };
        shellInit = mkLines "Shell Init shim.";
        loginShellInit = mkLines "Login Shell Init shim.";
        interactiveShellInit = mkLines "Interactive Shell Init shim.";
        shellAliases = lib.mkOption {
          description = "Attrs shim for aliases.";
          default = {};
          type = lib.types.attrs;
        };
      };

      # WIP: this will break Babelfish
      system.build.setEnvironment = lib.mkOption {
        description = "Dummy option only.";
        type = lib.types.str;
        default = "";
      };
    };

    config = {
      programs.fish = {
        enable = true;
        #useBabelfish = true;
      };
    };
  };
}
