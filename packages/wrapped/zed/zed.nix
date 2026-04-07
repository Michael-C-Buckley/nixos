{
  config,
  lib,
  ...
}: let
  inherit (config.flake.custom.wrappers) mkZedConfig mkZedPkgList;
in {
  flake.custom.wrappers = {
    mkZedPkgList = pkgs:
      with pkgs; [
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

  perSystem = {pkgs, ...}: let
    runtimeEnv = pkgs.buildEnv {
      name = "zed-runtime-env";
      pathsToLink = ["/bin"];
      paths = mkZedPkgList {inherit pkgs;};
    };
  in {
    packages = {
      zeditor = pkgs.symlinkJoin {
        name = "zeditor";
        paths = [pkgs.zed-editor];
        nativeBuildInputs = [pkgs.makeWrapper];
        meta.mainProgram = "zeditor";
        postBuild = ''
          wrapProgram $out/bin/zeditor \
          --prefix PATH : ${runtimeEnv}/bin \
          --set FONTCONFIG_FILE ${pkgs.makeFontsConf {fontDirectories = with pkgs; [ibm-plex lilex];}}
        '';
      };

      zedConfig = mkZedConfig {inherit pkgs;};
      zedPkgs = mkZedPkgList {inherit pkgs;};
    };
  };
}
