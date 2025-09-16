# This config is extremely verbose and broken up to be tolerable
{lib, ...}: let
  commonLangs = builtins.listToAttrs (map (a: {
    name = a;
    value = {format = "(via [$symbol($version )]($style))";};
  }) (import ./commonLangs.nix));
in {
  hjem.users.michael.rum.programs.starship = {
    enable = true;
    transience.enable = true;
    integrations = {
      fish.enable = true;
      zsh.enable = true;
    };

    settings =
      # These languages have duplicated formats
      commonLangs
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

        os = {
          format = "[\\[ \\]]($style)";
          style = "bold blue";
          disabled = false;
        };

        username = {
          style_user = "white bold";
          style_root = "black bold";
          format = "[$user]($style)[](green bold)";
          disabled = false;
          show_always = true;
        };

        nix_shell = {
          impure_msg = "[impure shell](bold red)";
          pure_msg = "[pure shell](bold green)";
          unknown_msg = "[unknown shell](bold yellow)";
          format = "[(\($name\) $state) ](bold blue)";
        };

        directory = {
          format = "[$path]($style)[ $read_only]($read_only_style) ";
          read_only = "🔒";
          truncate_to_repo = true;
          truncation_length = 0;
          truncation_symbol = "…/";
          repo_root_format = "[ ]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) ";
          before_repo_root_style = "blue";
          repo_root_style = "bold blue";
        };

        direnv = {
          disabled = false;
          format = "[$symbol]($style)";
          symbol = "󰚝 ";
        };

        buf = {
          format = "(with [$symbol$version ]($style))";
        };

        c = {
          format = "(via [$symbol($version(-$name) )]($style))";
        };

        dotnet = {
          format = "(via [$symbol($version )(🎯 $tfm )]($style))";
        };

        elixir = {
          format = "(via [$symbol($version \\(OTP $otp_version\\) )]($style))";
        };

        ocaml = {
          format = "(via [$symbol($version )(\\($switch_indicator$switch_name\\) )]($style))";
        };

        package = {
          format = "(is [$symbol$version]($style) )";
        };

        python = {
          format = "(via [\${symbol}\${pyenv_prefix}(\${version} )(\\($virtualenv\\) )]($style))";
        };

        raku = {
          format = "(via [$symbol($version-$vm_version )]($style))";
        };
      };
  };
}
