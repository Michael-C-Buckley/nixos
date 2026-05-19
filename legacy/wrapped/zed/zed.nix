{
  config,
  lib,
  ...
}: {
  flake.custom.wrappers = {
    mkZedConfig = {
      pkgs,
      extraConfig ? {},
    }:
      pkgs.runCommand "zed-settings.json" {
        nativeBuildInputs = [pkgs.biome];
        json = builtins.toJSON (lib.recursiveUpdate (import ./_settings.nix) extraConfig);
        passAsFile = ["json"];
      } ''
        biome format --stdin-file-path settings.json < "$jsonPath" > $out
      '';
  };

  perSystem = {
    pkgs,
    system,
    ...
  }: {
    packages = {
      zeditor = pkgs.symlinkJoin {
        name = "zeditor";
        paths = [pkgs.zed-editor];
        nativeBuildInputs = [pkgs.makeWrapper];
        meta.mainProgram = "zeditor";
        postBuild = ''
          wrapProgram $out/bin/zeditor \
          --prefix PATH : ${config.flake.packages.${system}.zedPkgs}/bin \
          --set FONTCONFIG_FILE ${pkgs.makeFontsConf {fontDirectories = with pkgs; [ibm-plex lilex];}}
        '';
      };

      zedConfig = config.flake.custom.wrappers.mkZedConfig {inherit pkgs;};
      zedPkgs = pkgs.buildEnv {
        name = "zed-runtimeenv";
        pathsToLink = ["/bin"];
        paths = with pkgs; [
          # Nix
          alejandra
          nil
          nixd
          statix

          # Go
          go
          gopls
          gofumpt

          # Rust
          rust-analyzer
          rustfmt

          # Python
          python3
          ruff
          basedpyright

          # Yaml
          yaml-language-server
        ];
      };
    };
  };
}
