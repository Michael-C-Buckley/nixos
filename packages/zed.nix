# Wrapped Zed for fonts and other binary tooling
# Settings excluded since Zed does not do well with immutable files there
{
  pkgs,
  zed-editor,
  fontDirectories ? with pkgs; [
    ibm-plex
    lilex
  ],
  ...
}:
let
  zedPkgs = pkgs.buildEnv {
    name = "zed-runtimeenv";
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
    ];
  };
in
pkgs.symlinkJoin {
  name = "zeditor";
  paths = [ zed-editor ];
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  meta.mainProgram = "zeditor";
  postBuild = ''
    wrapProgram $out/bin/zeditor \
    --prefix PATH : ${zedPkgs}/bin \
    --set FONTCONFIG_FILE ${pkgs.makeFontsConf { inherit fontDirectories; }}
  '';
}
