# My fish configuration pre-bundled with starship and configs for both
# NOTICE: Apparently using this with NixOS has some mechanism replacing the starship path,
#  thus that is wrapped and explicitly added on its own as well
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
      paths = [pkgs.fish];
      buildInputs = with pkgs; [
        eza
        bat
        starship
      ];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/fish \
          --add-flags "--init-command 'source ${config}'" \
          --prefix PATH : ${pkgs.lib.makeBinPath [pkgs.starship]}
      '';
      passthru.shellPath = "/bin/fish";
    };
  };
}
