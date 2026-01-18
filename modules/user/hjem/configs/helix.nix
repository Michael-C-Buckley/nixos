# Helix does not support language in the default config, so I've chosen to not
# wrap the config and instead use smfh, of which keep mutable with initial state
{config, ...}: {
  flake.hjemConfigs.helix = {pkgs, ...}: {
    hjem.users.michael = {
      packages = [config.flake.packages.${pkgs.stdenv.hostPlatform.system}.helix];

      files = {
        ".config/helix/languages.toml" = {
          type = "copy";
          permissions = "0644";
          source = pkgs.writeText "helix-languages" ''
            [language-server.ty]
            command = "ty"
            args = ["server"]

            [[language]]
            name = "nix"
            auto-format = true
            formatter = {command = "alejandra"}

            [[language]]
            name = "python"
            auto-format = false
            formatter = {command = "ruff", args = ["format", "--quiet", "-"]}
            language-servers = ["ty", "basedpyright"]

            [language.debugger]
            name = "debugpy"
            transport = "stdio"
            command = "python3"
            args = ["-m",  "debugpy.adapter"]

            [[language.debugger.templates]]
            name = "source"
            request = "launch"
            completion = [ { name = "entrypoint", completion = "filename", default = "." } ]
            args = { mode = "debug", program = "{0}"}
          '';
        };

        ".config/helix/config.toml" = {
          type = "copy";
          permissions = "0644";
          source = pkgs.writers.writeTOML "helix-config" {
            theme = "ayu_dark";
            editor = {
              line-number = "relative";
              bufferline = "multiple";
              cursorline = true;
              true-color = true;
              rulers = [120];
              end-of-line-diagnostics = "hint";

              inline-diagnostics = {
                cursor-line = "error";
                other-lines = "disable";
              };

              cursor-shape = {
                insert = "bar";
                normal = "block";
                select = "underline";
              };

              file-picker.hidden = false;

              indent-guides = {
                character = "╎";
                render = true;
              };
            };

            keys = {
              normal = {
                "A-," = "goto_previous_buffer";
                "A-." = "goto_next_buffer";
                A-w = ":buffer-close";
                A-x = "extend_to_line_bounds";
                A-r = ":reload-all";
                X = "select_line_above";
              };
              select = {
                A-x = "extend_to_line_bounds";
                X = "select_line_above";
              };
            };
          };
        };
      };
    };
  };
}
