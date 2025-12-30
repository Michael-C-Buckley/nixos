{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: let
    jail = inputs.jail.lib.init pkgs;
    inherit (jail.combinators) network gui readonly rw-bind noescape;
    homeBind = path: (rw-bind (noescape path) (noescape path));

    features = [
      network
      gui
      (readonly "/nix/store")
      (homeBind "~/.local/share/applications/")
      (homeBind "~/Downloads")
      (homeBind "~/.librewolf")
      (homeBind "~/.cache/librewolf/")
    ];

    mkLibrewolf = pkg: jail "librewolf" pkg features;
  in
    # Bwrap only for linux
    lib.optionalAttrs (lib.hasSuffix "linux" system) {
      packages.librewolf = mkLibrewolf pkgs.librewolf;
    };
}
