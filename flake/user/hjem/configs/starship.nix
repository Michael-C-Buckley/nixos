# This config is extremely verbose and broken up to be tolerable
{lib, ...}: {
  hjem.users.michael.rum.programs.starship = {
    enable = true;
    transience.enable = true;
    integrations = {
      fish.enable = true;
      zsh.enable = true;
    };

    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$python"
        "$custom"
        "$sudo"
        "$cmd_duration"
        "$fill"
        "$nix_shell"
        "$guix_shell"
        "$os"
        "$line_break"
        "$battery"
        "$status"
        "$character"
      ];

      right_format = lib.concatStrings [
        "$time"
      ];

      time = {
        disabled = false;
        format = "[< $time >]($style) ";
      };

      cmd_duration = {
        min_time = 100;
      };

      fill = {
        symbol = " ";
      };

      # WIP: not yet working
      os = {
        format = "[\\[ \\]]($style)";
        style = "bold blue";
        disabled = true;
        symbols = {
          Alpine = "";
          Debian = "";
          FreeBSD = "";
          Windows = "";
          Ubuntu = "";
          Macos = "󰀵";
          NixOS = "";
          Illumos = "";
        };
      };

      username = {
        style_user = "white bold";
        style_root = "black bold";
        format = "[$user]($style)[](green bold) ";
        disabled = false;
      };

      nix_shell = {
        impure_msg = "[impure](bold yellow)";
        pure_msg = "[pure](bold white)";
        unknown_msg = "[unknown](bold red)";
        symbol = "❄️";
        format = "[(\($name\)$symbol$state)](bold blue)";
      };

      directory = {
        format = "[$path]($style)[ $read_only]($read_only_style) ";
        read_only = "🔒";
        truncate_to_repo = true;
        truncation_length = 0;
        truncation_symbol = "";
        repo_root_format = "[ ]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) ";
        before_repo_root_style = "blue";
        repo_root_style = "bold blue";
      };

      python = {
        format = "(via [\${symbol}\${pyenv_prefix}(\${version} )(\\($virtualenv\\) )]($style))";
      };
    };
  };
}
