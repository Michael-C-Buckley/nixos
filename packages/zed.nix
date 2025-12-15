# Just a simple way to put some tools in the Zed path
{
  perSystem = {pkgs, ...}: let
    zedInputs = with pkgs; [
      # Nix
      alejandra
      nil
      nixd
      statix

      # Go
      go
      gopls
      gofumpt

      # Python
      python3
      ruff
      pyrefly
      pyright
      basedpyright
    ];
  in {
    packages.zeditor = pkgs.symlinkJoin {
      name = "zeditor";
      paths = [pkgs.zed-editor];
      buildInputs = zedInputs;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/zeditor \
        --prefix PATH : ${pkgs.lib.makeBinPath zedInputs}
      '';
    };
  };
}
