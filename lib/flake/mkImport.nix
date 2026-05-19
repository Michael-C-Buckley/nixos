# Returns a list of paths that are nix files but don't have a leading `_` in the filename
# Inspired by import-tree by Vic
{inputs}: let
  inherit (inputs.nixpkgs.lib) hasPrefix;
  inherit (inputs.nixpkgs.lib.fileset) toList fileFilter;
in
  path: toList (fileFilter (f: f.hasExt "nix" && !(hasPrefix "_" f.name)) path)
