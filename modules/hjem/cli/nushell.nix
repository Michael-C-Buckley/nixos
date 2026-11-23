# Nushell for a hjem home: the stock package, with the wrapper's autoload set
# linked into Nushell's per-user vendor autoload directory. Tools come from the
# home's profile instead of the wrapper's PATH.
{ pkgs, ... }: {
  imports = [ ./starship.nix ];

  packages = [ pkgs.localNushell ];
  xdg.data.files."nushell/vendor/autoload".source = pkgs.localNushell.autoload;
}
