# Just a simple way to put some tools in the Zed path
# This also bwraps the linux variant
{
  config,
  lib,
  ...
}: let
  inherit (config.flake.custom.wrappers) mkZedConfig;
in {
  flake.custom.wrappers.mkZedConfig = {
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

  perSystem = {
    pkgs,
    lib,
    system,
    ...
  }: let
    runtimeEnv = pkgs.buildEnv {
      name = "zed-runtime-env";
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
    isMac = lib.hasSuffix "darwin" pkgs.stdenv.hostPlatform.system;

    fonts =
      if isMac
      then ""
      else "--set FONTCONFIG_FILE ${pkgs.makeFontsConf {fontDirectories = with pkgs; [ibm-plex lilex];}}";

    macScript = pkgs.writeShellScriptBin "zed-mac-script" ''
      export __PATH_HELPER_LOADED=1
      export PATH="${runtimeEnv}/bin:$PATH"
      exec -a "$0" "${lib.getExe pkgs.zed-editor}" "$@"
    '';

    localPkg = pkgs.symlinkJoin {
      name = "zeditor";
      paths = [pkgs.zed-editor];
      nativeBuildInputs = [pkgs.makeWrapper];
      meta.mainProgram = "zeditor";
      postBuild = ''
        wrapProgram $out/bin/zeditor \
        --prefix PATH : ${runtimeEnv}/bin ${fonts}

        cp ${lib.getExe macScript} $out/bin/zed-mac


        ${
          if isMac
          then "sed -i '1s|^#!.*|#!/bin/bash -e|' $out/bin/zeditor"
          else ""
        }
      '';
    };

    jail = (import "${config.flake.npins.jail}/lib").init pkgs;
    inherit (jail.combinators) gui gpu readonly rw-bind noescape;
    homeBind = path: (rw-bind (noescape path) (noescape path));

    # These are my directories I use, you likely want to adjust this
    bwrapFeatures = [
      gui
      gpu
      (readonly "/nix/store")
      (homeBind "~/nixos") # where I keep my system flake
      (homeBind "~/projects") # The rest of where I usually keep projects
      (homeBind "~/.config/zed")
      (homeBind "~/.cache/zed")
      (homeBind "~/.local/share/zed")
    ];
  in {
    packages =
      {
        zeditor = localPkg;
        zedConfig = mkZedConfig {inherit pkgs;};
      }
      // lib.optionalAttrs (lib.hasSuffix "linux" system) {
        zeditor-jailed = jail "zeditor" localPkg bwrapFeatures;
      };
  };
}
