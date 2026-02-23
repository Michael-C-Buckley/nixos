{
  perSystem = {
    pkgs,
    pkgs-small,
    ...
  }: let
    buildInputs = with pkgs; [
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

      # Fonts
      cascadia-code
      nerd-fonts.symbols-only
      vista-fonts
    ];
  in {
    # Wrap packages for the path but no need for extensions
    # as I use settings sync for the times I use VScode
    packages.vscode = pkgs.symlinkJoin {
      name = "code";
      paths = [pkgs-small.vscode]; # Pull from unstable small for a needed update
      inherit buildInputs;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/code \
        --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
      '';
    };
  };
}
