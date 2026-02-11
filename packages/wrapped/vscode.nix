{
  perSystem = {pkgs, ...}: let
    buildInputs = with pkgs; [
      python3
      nil
      nixd
      sops
      uv
      neovim
    ];
  in {
    # Wrap packages for the path but no need for extensions
    # as I use settings sync for the times I use VScode and
    packages.vscode = pkgs.symlinkJoin {
      name = "code";
      paths = [pkgs.vscode];
      inherit buildInputs;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/code \
        --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
      '';
    };
  };
}
