# My Helix is a fully configured and immutable config experience
# I bundle all the tools I normally use, which includes LSPs
#
# This derivation may be quite big as the number of dependencies is
# not trivial and some are quite large, like basedpyright
#
# The XDG override was needed as passing the config flag did not
# allow for the languages config to be wrapped with it
{
  config,
  lib,
  ...
}: let
  inherit (config.flake.wrappers) mkHelixConfig mkHelixLanguages;
  inherit (lib) importTOML recursiveUpdate;
in {
  perSystem = {pkgs, ...}: {
    packages.helix = config.flake.wrappers.mkHelix {inherit pkgs;};
  };

  flake.wrappers = {
    mkHelixLanguages = {
      pkgs,
      extraLang,
    }:
      pkgs.writers.writeTOML "helix-languages" (
        recursiveUpdate
        (importTOML ./languages.toml)
        extraLang
      );
    mkHelixConfig = {
      pkgs,
      extraCfg,
    }:
      pkgs.writers.writeTOML "helix-config" (
        recursiveUpdate
        (import ./_config.nix)
        extraCfg
      );

    mkHelix = {
      pkgs,
      pkg ? pkgs.helix,
      extraRuntimeInputs ? [],
      extraCfg ? {},
      extraLang ? {},
    }: let
      runtimeEnv = pkgs.buildEnv {
        name = "helix-runtime-env";
        pathsToLink = ["/bin"];

        paths = with pkgs;
          [
            # Nix
            alejandra
            nil
            nixd
            # Rust
            rust-analyzer
            rustfmt
            # Python
            ruff
            basedpyright
            # Yaml/json
            biome
            yaml-language-server
            vscode-json-languageserver
          ]
          ++ extraRuntimeInputs;
      };

      langs = mkHelixLanguages {inherit pkgs extraLang;};
      cfg = mkHelixConfig {inherit pkgs extraCfg;};

      printCfg = config.flake.functions.printConfig {
        inherit cfg pkgs;
        name = "hx-print-config";
      };

      printLangs = config.flake.functions.printConfig {
        inherit pkgs;
        name = "hx-print-languages";
        cfg = langs;
      };
    in
      pkgs.symlinkJoin {
        name = "hx";
        paths = [pkg];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out
          cp -r ${printLangs}/bin $out

          mkdir $out/helix
          ln -s ${cfg} $out/helix/config.toml
          ln -s ${langs} $out/helix/languages.toml
          wrapProgram $out/bin/hx \
            --prefix PATH : ${runtimeEnv}/bin \
            --set XDG_CONFIG_HOME $out
        '';
      };
  };
}
