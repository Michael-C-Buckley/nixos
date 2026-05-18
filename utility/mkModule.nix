# Creates an attribute set of modules intended to be used with something such as nixosModules
# The namespace is all the directory structure separated by dashes with the extension removed
{
  nixpkgs,
  mkImport,
}: let
  inherit (builtins) concatStringsSep unsafeDiscardStringContext;
  inherit (nixpkgs.lib) removeSuffix splitString drop;
in
  path:
    builtins.listToAttrs
    (map (
      a: {
        # Unsafe disregard so it doesn't complain about the store path
        name = unsafeDiscardStringContext (
          # Trim the extension
          removeSuffix ".nix"
          # Put it together as a module name with dashes
          (concatStringsSep "-"
            # Split up the filename
            (drop 4 (
              splitString "/" a
            )))
        );
        value = import a;
      }
    ) (mkImport path))
