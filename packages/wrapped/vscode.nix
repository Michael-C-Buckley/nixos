{
  perSystem = {pkgs, ...}: let
    runtimeEnv = pkgs.buildEnv {
      name = "vscode-runtime-env";
      pathsToLink = ["/bin"];
      paths = with pkgs; [
        sops

        # Python - LSP is invariably Pylance, via extension + sync
        python3
        uv
        ruff

        # Nix
        alejandra
        nil
        nixd

        # Rust
        rust-analyzer
        rustfmt
      ];
    };
    fontDirectories = with pkgs; [
      cascadia-code
      nerd-fonts.symbols-only
      vista-fonts
    ];
  in {
    # Wrap packages for the path but no need for extensions
    # as I use settings sync for the times I use VScode
    packages.vscode = pkgs.symlinkJoin {
      name = "code";
      paths = [pkgs.vscode]; # Pull from unstable small for a needed update
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/code \
        --prefix PATH : ${runtimeEnv}/bin \
        --set FONTCONFIG_FILE ${pkgs.makeFontsConf {inherit fontDirectories;}}
      '';
    };
  };
}
