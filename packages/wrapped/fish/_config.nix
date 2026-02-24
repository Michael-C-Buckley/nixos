{
  pkgs,
  starshipConfig,
  gitConfig,
  env ? {},
  extraConfig ? "",
  aliases ? {},
}: let
  inherit (pkgs.lib) getExe;

  aliasCommands = pkgs.lib.concatStringsSep "\n" (
    pkgs.lib.mapAttrsToList (name: value: "    alias ${name}='${value}'") aliases
  );

  envCommands = pkgs.lib.concatStringsSep "\n" (
    pkgs.lib.mapAttrsToList (name: value: "    set -gx ${name} '${toString value}'") env
  );

  # Create unique identifier including env vars to prevent overwrites
  configHash = builtins.substring 0 8 (builtins.hashString "sha256" "${extraConfig}${toString (builtins.attrNames aliases)}${toString (builtins.attrNames env)}${toString (builtins.attrValues env)}");
in
  pkgs.writeText "fish-init-${configHash}.fish" ''
    set -g fish_greeting ""
    # Fallback default prompt
    fish_config prompt choose arrow

    # Initialize starship with custom config and explicit path
    set -x STARSHIP_CONFIG ${starshipConfig}
    ${getExe pkgs.starship} init fish | source

    function starship_transient_prompt_func
      ${getExe pkgs.starship} module character
    end

    enable_transience

    # Set Git's config path
    set -x GIT_CONFIG_GLOBAL ${gitConfig}

    # Environment Variables
    ${envCommands}

    # Aliases
    ${aliasCommands}

    # Dynamically find my signing key
    ${getExe pkgs.nushell} ${../resources/shells/key_script.nu}


    # Functions (session-scoped to avoid conflicts)
    function show --description 'Show VTY command output'
      sudo vtysh -c "show $argv"
    end

    function fcd --description 'Interactive directory change with fzf'
      set -l selected_path (${getExe pkgs.fd} . | ${getExe pkgs.fzf} --height 40% --reverse)

      if test -n "$selected_path"
          if test -d "$selected_path"
              cd "$selected_path"
          else
              cd (dirname "$selected_path")
          end
      end
    end

    direnv hook fish | source

    # Extra config
    ${extraConfig}
  ''
