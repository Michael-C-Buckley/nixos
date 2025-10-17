# Just a simple way to put some tools in the Zed path
{
  perSystem = {pkgs, ...}: let
    zedInputs = with pkgs; [
      nil
      nixd
      pyright
      gopls

      # Formatters
      alejandra
      black
      gofumpt

      # Build tools
      python3
      go
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
