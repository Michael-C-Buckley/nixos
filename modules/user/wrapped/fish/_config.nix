{
  pkgs,
  env ? {},
  extraConfig ? "",
  extraAliases ? {},
}: let
  inherit (pkgs) starship fd fzf;
  starshipConfig = import ../starship/_config.nix {inherit pkgs;};
  aliases = import ../resources/shells/_aliases.nix;
  allAliases = aliases.common // aliases.fish // extraAliases;

  # Generate fish alias commands
  aliasCommands = pkgs.lib.concatStringsSep "\n" (
    pkgs.lib.mapAttrsToList (name: value: "    alias ${name}='${value}'") allAliases
  );

  # Generate env export commands
  envCommands = pkgs.lib.concatStringsSep "\n" (
    pkgs.lib.mapAttrsToList (name: value: "    set -gx ${name} '${value}'") env
  );

  # Create unique identifier including env vars to prevent overwrites
  configHash = builtins.substring 0 8 (builtins.hashString "sha256" "${extraConfig}${toString (builtins.attrNames extraAliases)}${toString (builtins.attrNames env)}${toString (builtins.attrValues env)}");
in
  pkgs.writeText "fish-init-${configHash}.fish" ''
    set -g fish_greeting ""
    fish_config prompt choose arrow

    # Initialize starship with custom config and explicit path
    set -x STARSHIP_CONFIG ${starshipConfig}
    ${starship}/bin/starship init fish | source

    function starship_transient_prompt_func
      ${starship}/bin/starship module character
    end

    enable_transience

    # Environment Variables
    ${envCommands}

    # Aliases
    ${aliasCommands}

    # Functions (session-scoped to avoid conflicts)
    function show --description 'Show VTY command output'
      sudo vtysh -c "show $argv"
    end

    function fcd --description 'Interactive directory change with fzf'
      set -l selected_path (${fd}/bin/fd . | ${fzf}/bin/fzf --height 40% --reverse)

      if test -n "$selected_path"
          if test -d "$selected_path"
              cd "$selected_path"
          else
              cd (dirname "$selected_path")
          end
      end
    end

    direnv hook fish | source

    # Set GPG_TTY for GPG agent
    set -x GPG_TTY (tty)

    # Set some defaults that I use
    set PAGER bat
    set MANPAGER "sh -c 'col -bx | bat -l man -p'"

    # Extra config
    ${extraConfig}
  ''
