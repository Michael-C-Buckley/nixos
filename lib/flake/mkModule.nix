# Creates an attribute set of modules intended to be used with something such as nixosModules
# The namespace is all the directory structure separated by dashes with the extension removed
{inputs}: let
  mkImport = import ./mkImport.nix {inherit inputs;};
  inherit (builtins) unsafeDiscardStringContext;
  inherit (inputs.nixpkgs.lib) removeSuffix splitString last;
in
  path:
    builtins.listToAttrs
    (map (
      a: {
        # Unsafe disregard so it doesn't complain about the store path
        name = unsafeDiscardStringContext (
          # Trim the extension
          removeSuffix ".nix"
          # Get the filename only
          (last (
            splitString "/" a
          ))
        );
        value = import a;
      }
    ) (mkImport path))
