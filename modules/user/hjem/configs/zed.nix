{config, ...}: {
  flake.modules.nixos.hjem-zed = {pkgs, ...}: {
    hjem.users.michael.rum.programs.zed = {
      enable = true;
      package = config.flake.packages.${pkgs.system}.zeditor;

      settings = {
        base_keymap = "VSCode";

        load_direnv = "shell_hook";

        diagnostics.inline = {
          enabled = true;
          min_column = 80;
        };

        tabs = {
          file_icons = true;
          git_status = true;
          show_diagnostics = "all";
        };

        toolbar.code_actions = true;

        git.git_gutter = "tracked_files";

        agent = {
          default_profile = "write";
          single_file_review = true;

          default_model = {
            provider = "copilot_chat";
            model = "gpt-4.1";
          };
        };

        telemetry = {
          diagnostics = false;
          metrics = false;
        };

        vim_mode = true;
        relative_line_numbers = true;

        ui_font_size = 16;
        buffer_font_size = 15;
        buffer_font_weight = 400;

        theme = {
          mode = "system";
          light = "Ayu Light";
          dark = "Ayu Dark";
        };

        languages = {
          Nix = {
            formatter.external = {
              command = "alejandra";
              arguments = [
                "--quiet"
                "--"
              ];
            };
            language_servers = [
              "nixd"
              "nil"
            ];
          };
        };
      };
      # End of settings
    };
  };
}
