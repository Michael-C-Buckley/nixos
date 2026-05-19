{
  inputs,
  pkgs,
  system,
  ...
}: {
  zeditor = pkgs.symlinkJoin {
    name = "zeditor";
    paths = [pkgs.zed-editor];
    nativeBuildInputs = [pkgs.makeWrapper];
    meta.mainProgram = "zeditor";
    postBuild = ''
      wrapProgram $out/bin/zeditor \
      --prefix PATH : ${inputs.self.packages.${system}.zedPkgs}/bin \
      --set FONTCONFIG_FILE ${pkgs.makeFontsConf {fontDirectories = with pkgs; [ibm-plex lilex];}}
    '';
  };

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
}
