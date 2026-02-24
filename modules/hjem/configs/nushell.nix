# My main user shell is Nushell, via the wrapper within this flake
# This exists to patch in any nixos common elements not available
# in the wrapper directly
{
  flake.hjemConfigs.nushell = {
    config,
    lib,
    ...
  }: let
    inherit (config.hjem.users.michael.environment) sessionVariables;
    envAttrs =
      "# --- Environmenmt Attributes from Session Variables ---"
      + (lib.concatStringsSep "\n" (
        lib.mapAttrsToList (k: v: "$env.${k} = ${builtins.toJSON v}") sessionVariables
      ))
      + "\n\n";
  in {
    hjem.users.michael = {
      xdg.config.files."nushell/host.nu" = {
        type = "copy";
        permissions = "0644";
        text = envAttrs;
      };
    };
  };
}
