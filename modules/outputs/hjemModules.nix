{config, ...}: let
  # Change _class to darwin for all hjem modules
  toDarwin = module:
    if builtins.isFunction module
    then args: (module args) // {_class = "darwin";}
    else if builtins.isAttrs module
    then module // {_class = "darwin";}
    else module;
in {
  flake.hjemModules = builtins.mapAttrs (_: toDarwin) config.flake.modules.hjem;
}
