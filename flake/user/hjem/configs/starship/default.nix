# This config is extremely verbose and broken up to be tolerable
{lib, ...}: {
  hjem.users.michael.rum.programs.starship = {
    enable = true;
    transience.enable = true;
    integrations = {
      fish.enable = true;
      zsh.enable = true;
    };

    settings =
      # These languages have duplicated formats
      (import ./languages.nix)
      // {
        # This is a very long list that resolves to a long string
        format = lib.concatStrings (import ./settingsFormat.nix);

        right_format = "$time";

        time = {
          disabled = false;
          format = "[< $time >]($style) ";
        };

        cmd_duration = {
          min_time = 5000;
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
          repo_root_format = "[ ]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) ";
          before_repo_root_style = "blue";
          repo_root_style = "bold blue";
        };

        direnv = {
          disabled = false;
          format = "[$symbol]($style)";
          symbol = "󱂷 ";
        };
      };
  };
}
