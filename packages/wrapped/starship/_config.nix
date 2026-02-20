{
  pkgs,
  extraConfig ? {},
  useCharacter ? false,
}: let
  tomlFormat = pkgs.formats.toml {};

  format = pkgs.lib.concatStringsSep "" ([
      "$hostname"
      "$directory"
      "$git_branch"
      "$git_status"
      "$cmd_duration"
      "$fill"
      "$nix_shell"
      "$time"
      "\n"
      "$battery"
      "$jobs"
      "$python"
    ]
    ++ (pkgs.lib.optionals useCharacter ["$character"]));

  baseConfig = {
    inherit format;

    directory.style = "cyan";
    fill.symbol = " ";

    hostname = {
      format = "[$hostname:]($style)";
      style = "fg:71";
    };

    time = {
      disabled = false;
      format = " [$time]($style) ";
      style = "grey";
    };

    cmd_duration = {
      format = "[$duration]($style) ";
      style = "yellow";
    };

    nix_shell = {
      impure_msg = "[✱ ](yellow)";
      pure_msg = "[✱ ](green)";
      unknown_msg = "[✱ ](red)";
      format = "$state";
    };

    git_branch = {
      format = "[git:\\(](blue)[$branch]($style)[\\)](blue)";
      style = "fg:1";
    };

    git_status = {
      format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style) ";
      style = "cyan";
      conflicted = "​;";
      untracked = "​";
      modified = "​";
      staged = "​";
      renamed = "​";
      deleted = "​";
      stashed = "≡";
    };

    git_state = {
      format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
      style = "bright-black";
    };

    python = {
      format = "[$virtualenv]($style) ";
      style = "bright-black";
    };
  };
in
  tomlFormat.generate "starship.toml" (pkgs.lib.recursiveUpdate baseConfig extraConfig)
