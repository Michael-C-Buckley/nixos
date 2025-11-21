{
  pkgs,
  lib,
}: let
  starshipConfig = import ../starship/_config.nix {inherit pkgs;};
  aliases = import ../resources/shells/_aliases.nix;
  allAliases = aliases.common // aliases.fish;

  # Generate fish alias commands
  aliasCommands = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: value: "    alias ${name}='${value}'") allAliases
  );
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

    # Aliases
    ${aliasCommands}

    # Functions
    function show
      vtysh -c "show $argv"
    end
  ''
