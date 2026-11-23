# Add my local packages to more easily gain access to them
# However, make it distinct so it can be more explicitly identified
{ inputs, configPaths, ... }:
_final: prev:
let
  inherit (prev) lib;
  localPackages = import ./. {
    pkgs = prev;
    inherit inputs configPaths;
  };

  # Make the packages distinct by prepending `local` and capitalizing the
  # first of the real name to make lower camel case
  localName =
    name:
    "local"
    + lib.concatMapStrings (
      part: lib.toUpper (builtins.substring 0 1 part) + builtins.substring 1 (-1) part
    ) (lib.splitString "-" name);
in
lib.mapAttrs' (name: package: lib.nameValuePair (localName name) package) localPackages
