# Wrapped helix, includes my configs and the tools needed for them
{ pkgs, helix, ... }:
let
  configHome = pkgs.linkFarm "helix-config" [
    {
      name = "helix";
      path = ./.;
    }
  ];
  runtimeEnv = pkgs.buildEnv {
    name = "hx-runtime-env";
    paths = with pkgs; [
      # Nix
      nil
      nixfmt
      # Python
      ruff
      basedpyright
      # Go
      go
      gopls
      # Yaml/json
      biome
      yaml-language-server
      vscode-json-languageserver
      # Other
      nushell
    ];
  };
in
pkgs.symlinkJoin {
  name = "hx";
  paths = [ helix ];
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  postBuild =
    # bash
    ''
      wrapProgram $out/bin/hx \
        --prefix PATH : ${runtimeEnv}/bin \
        --set XDG_CONFIG_HOME ${configHome}
    '';
}
