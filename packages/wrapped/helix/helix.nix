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
      buildInputs = with pkgs;
        [
          # Nix
          alejandra
          nil
          nixd
          # Rust
          rust-analyzer
          rustfmt
          # Python
          python314Packages.jedi-language-server
          ruff
          pyrefly
          # Yaml/json
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
          mkdir $out/helix
          ln -s ${mkHelixConfig {inherit pkgs extraCfg;}} $out/helix/config.toml
          ln -s ${mkHelixLanguages {inherit pkgs extraLang;}} $out/helix/languages.toml
          wrapProgram $out/bin/hx \
            --prefix PATH : ${pkgs.lib.makeBinPath buildInputs} \
            --set XDG_CONFIG_HOME $out
        '';
      };
  };
}
