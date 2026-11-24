# Wrapped Gram for fonts and other binary tooling
{
  pkgs,
  gram,
  fontDirectories ? with pkgs; [
    ibm-plex
    lilex
  ],
  ...
}:
let
  gramPkgs = pkgs.buildEnv {
    name = "gram-runtimeenv";
    pathsToLink = [ "/bin" ];
    paths = with pkgs; [
      # Nix
      nixfmt
      nil
      statix

      # Go
      go
      gopls
      gofumpt

      # Python
      python3
      ruff
      basedpyright

      # Yaml
      yaml-language-server

      # Json
      biome

      # Toml
      taplo

      # Lua
      lua-language-server
    ];
  };
in
pkgs.symlinkJoin {
  name = "gramitor";
  paths = [ gram ];
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  meta.mainProgram = "gram";
  postBuild = ''
    wrapProgram $out/bin/gram \
    --prefix PATH : ${gramPkgs}/bin \
    --set FONTCONFIG_FILE ${pkgs.makeFontsConf { inherit fontDirectories; }}
  '';
}
