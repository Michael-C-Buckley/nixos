# Prompt is a fusion of a few styles:
#  - Robby Russell: directory & git branch
#  - Pure: git status & python virtualenv
#  - Spaceship: starship's 2 line default
#  - Custom: nix shell, time, etc
# Overall I wanted to created something to show useful info but not as much or loud
# as the default Starship prompt
{lib, ...}: {
  hjem.users.michael.rum.programs = {
    starship = {
      enable = true;
      transience.enable = true;
      integrations = {
        fish.enable = true;
        #nushell.enable = true; # Does not actually work
      };

      settings = {
        # Renders down to a single long string of all the components
        format = lib.concatStrings [
          "$directory"
          "$git_branch"
          "$git_state"
          "$git_status"
          "$cmd_duration"
          "$fill"
          "$nix_shell"
          "$username"
          "$hostname"
          "$time"
          "$line_break"
          "$battery"
          "$jobs"
          "$python"
          "$character"
        ];

        username.format = "[$user]($style)";
        directory.style = "cyan";
        fill.symbol = " ";

        hostname = {
          format = "[@$hostname]($style) ";
          style = "bold fg:71";
        };

        time = {
          disabled = false;
          format = "[$time]($style) ";
          style = "cyan";
        };

        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
        };

        nix_shell = {
          impure_msg = "[ ](yellow)";
          pure_msg = "[ ](green)";
          unknown_msg = "[ ](red)";
          format = "$state";
        };

        git_branch = {
          # Nix interpolation apparently requires double slash for escape, since one is subtracted
          format = "[git:\\((blue)[$branch]($style)[\\)](blue)";
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
