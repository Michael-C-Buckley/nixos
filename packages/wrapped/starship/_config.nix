{
  pkgs,
  lib ? pkgs.lib,
  overrides ? {},
}: let
  tomlFormat = pkgs.formats.toml {};

  baseConfig = {
    format = "$hostname$directory$git_branch$git_state$git_status$cmd_duration$fill$nix_shell$time\n$battery$jobs$python$character";

    directory.style = "cyan";
    fill.symbol = " ";

    hostname = {
      format = "[$hostname:]($style)";
      style = "fg:71";
    };

    time = {
      disabled = false;
      format = " [$time]($style) ";
      style = "cyan";
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
  tomlFormat.generate "starship.toml" (lib.recursiveUpdate baseConfig overrides)
