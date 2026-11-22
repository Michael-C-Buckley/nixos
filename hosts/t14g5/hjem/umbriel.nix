{ lib, ... }:
{
  custom.umbriel.settings = {
    output.eDP-1.workspaces = map toString (lib.range 1 10);
    keybinds = lib.listToAttrs (
      lib.concatMap (
        n:
        let
          key = if n == 10 then "0" else toString n;
          name = toString n;
        in
        [
          {
            name = "Mod+${key}";
            value = ''workspace-switch:"${name}"'';
          }
          {
            name = "Mod+Shift+${key}";
            value = ''window-move-to-workspace:"${name}"'';
          }
        ]
      ) (lib.range 1 10)
    );
  };
}
