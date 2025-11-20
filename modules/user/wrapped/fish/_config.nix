{
  pkgs,
  lib,
}: let
  starshipConfig = import ./_starship.nix {inherit pkgs;};
in
  pkgs.writeText "fish-init.fish" ''
    set -U fish_greeting
    fish_config prompt choose arrow

    # Initialize starship with custom config
    set -x STARSHIP_CONFIG ${starshipConfig}
    ${lib.getExe pkgs.starship} init fish | source

    function show
      vtysh -c "show $argv"
    end
  ''
