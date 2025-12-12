{
  perSystem = {pkgs, ...}: let
    buildInputs = with pkgs; [cascadia-code];
  in {
    packages.kitty = pkgs.symlinkJoin {
      name = "kitty";
      paths = [pkgs.kitty];
      inherit buildInputs;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/kitty \
          --add-flags "-c ${import ./_config.nix {inherit pkgs;}}" \
          --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
      '';
    };
  };
}
