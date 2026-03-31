# Just a simple way to put some tools in the Zed path
# This also bwraps the linux variant
{
  config,
  lib,
  ...
}: {
  flake.wrappers.mkZedConfig = {
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

    localPkg = pkgs.symlinkJoin {
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
        zedConfig = config.flake.wrappers.mkZedConfig {inherit pkgs;};
      }
      // lib.optionalAttrs (lib.hasSuffix "linux" system) {
        zeditor-jailed = jail "zeditor" localPkg bwrapFeatures;
      };
  };
}
