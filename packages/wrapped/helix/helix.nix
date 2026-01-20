{config, ...}: {
  perSystem = {pkgs, ...}: {
    packages.helix = config.flake.wrappers.mkHelix {
      inherit pkgs;
    };
  };

  flake.wrappers = {
    mkHelixLanguages = {pkgs}: pkgs.lib.importTOML ./languages.toml;

    mkHelixConfig = {
      pkgs,
      extra ? {},
    }:
      pkgs.writers.writeTOML "helix-config" {
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
      }
      // extra;

    mkHelix = {
      pkgs,
      pkg ? pkgs.helix,
      extraRuntimeInputs ? [],
    }: let
      buildInputs = with pkgs;
        [
          alejandra
          nil
          nixd
          basedpyright
          ty
          ruff
          yaml-language-server
          vscode-json-languageserver
        ]
        ++ extraRuntimeInputs;
    in
      pkgs.symlinkJoin {
        name = "hx";
        paths = [pkg];
        inherit buildInputs;
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/hx \
            --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
        '';
      };
  };
}
