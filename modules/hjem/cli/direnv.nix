{ configPaths, pkgs, ... }:
{
  imports = [ ../runtime.nix ];

  packages = with pkgs; [
    direnv
    nix-direnv
  ];
  xdg.config.files = {
    "direnv/direnv.toml".source = configPaths.direnv + "/direnv.toml";
    "direnv/direnvrc".source = configPaths.direnv + "/direnvrc";
    "direnv/lib/hjem-nix-direnv.sh".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
  };
}
