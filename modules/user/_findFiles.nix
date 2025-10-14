# Auto-detect and return an link-ready attrset of my home files
# It will link it in the same format in which it is created
{lib, ...}: let
  inherit (builtins) toString;
  inherit (lib.attrsets) listToAttrs;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.lists) map;
  inherit (lib.strings) removePrefix;

  findFiles = directory: let
    directoryPrefix = (toString directory) + "/";
  in
    listToAttrs
    (map
      (filepath: {
        name = removePrefix directoryPrefix (toString filepath);
        value.source = filepath;
      })
      (listFilesRecursive directory));
in
  findFiles ./files
