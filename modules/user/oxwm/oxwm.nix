{lib, ...}: {
  # Collect and expose the local files but remove the lua extension from the keyname
  flake.custom.userModules.oxwm =
    lib.mapAttrs'
    (name: _: {
      name = lib.removeSuffix ".lua" name;
      value = ./. + "/${name}";
    })
    (lib.filterAttrs
      (name: type: type == "regular" && lib.hasSuffix ".lua" name)
      (builtins.readDir ./.));
}
