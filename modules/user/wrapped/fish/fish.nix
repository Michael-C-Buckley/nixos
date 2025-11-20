# My fish configuration pre-bundled with starship and configs for both
{
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    config = import ./_config.nix {inherit pkgs lib;};
  in {
    packages.fish = pkgs.symlinkJoin {
      name = "fish";
      paths = [
        pkgs.fish
        pkgs.starship
      ];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/fish \
          --add-flags "--init-command 'source ${config}'" \
          --prefix PATH : ${pkgs.lib.makeBinPath [pkgs.starship]}
      '';
    };
  };
}
