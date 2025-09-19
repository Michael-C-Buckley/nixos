# This config is extremely verbose and broken up to be tolerable
{lib, ...}: {
  hjem.users.michael.rum.programs = {
    starship = {
      enable = true;
      transience.enable = true;
      integrations = {
        fish.enable = true;
        zsh.enable = false;
      };

      settings = {
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_state"
          "$git_status"
          "$cmd_duration"
          "$fill"
          "$nix_shell"
          "$time"
          "$line_break"
          "$battery"
          "$python"
          "$character"
        ];

        time = {
          disabled = false;
          format = "[$time]($style) ";
          style = "cyan";
        };

        cmd_duration = {
          min_time = 1000;
          format = "[$duration]($style) ";
          style = "yellow";
        };

        directory.style = "cyan";
        fill.symbol = " ";

        username = {
          style_user = "white bold";
          style_root = "black bold";
          format = "[$user]($style)[](green bold) ";
          disabled = false;
        };

        nix_shell = {
          impure_msg = "[ ](yellow)";
          pure_msg = "[ ](green)";
          unknown_msg = "[ ](red)";
          format = "$state";
        };

        git_branch = {
          # Nix interpolation apparently requires double slash for escape, since one is subtracted
          format = "[git:\\(](blue)[$branch]($style)[\\)](blue)";
          style = "bright-red";
        };

        git_status = {
          format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
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
          format = "\([$state( $progress_current/$progress_total)]($style)\) ";
          style = "bright-black";
        };

        python = {
          format = "[$virtualenv]($style) ";
          style = "bright-black";
        };
      };
    };
  };
}
