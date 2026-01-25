{config, ...}: {
  perSystem = {pkgs, ...}: let
    jail = (import "${config.flake.npins.jail}/lib").init pkgs;
    homeBind = with jail.combinators; path: (rw-bind (noescape path) (noescape path));

    features = with jail.combinators;
      [
        network
        (readonly "/nix/store")
      ]
      ++ [
        # The only directories I have projects in that I want to share with the app
        (homeBind "~/projects")
        (homeBind "~/nixos")
        # Permits the ability to see existing state that the app relies on
        (homeBind "~/.config/opencode")
        (homeBind "~/.cache/opencode")
        (homeBind "~/.local/share/opencode")
      ];
  in {
    packages = {
      opencode = jail "opencode" pkgs.opencode features;
    };
  };
}
