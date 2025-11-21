{
  pkgs,
  lib,
}: let
  starshipConfig = import ../starship/_config.nix {inherit pkgs;};
in
  pkgs.writeText "fish-init.fish" ''
    set -U fish_greeting
    fish_config prompt choose arrow

    # Clear any existing starship functions from parent shells
    functions -e fish_prompt fish_right_prompt starship_transient_prompt_func 2>/dev/null

    # Initialize starship with custom config and explicit path
    set -x STARSHIP_CONFIG ${starshipConfig}
    set -x PATH ${pkgs.starship}/bin $PATH
    ${lib.getExe pkgs.starship} init fish | source

    function show
      vtysh -c "show $argv"
    end
  ''
