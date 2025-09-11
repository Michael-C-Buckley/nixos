# This idea is something I got from Iynaix and LuminarLeaf
# Leaf: https://github.com/LuminarLeaf/arboretum/blob/c5babe771d969e2d99b5fb373815b1204705c9b1/modules/user/shell/cli-tools.nix#L32
# Iynaix: https://github.com/iynaix/dotfiles/blob/ab3e10520ac824af76b08fac20eeed9a4c3f100a/home-manager/shell/nix.nix#L351
{pkgs}:
pkgs.writeShellApplication {
  name = "ns";
  runtimeInputs = with pkgs; [fzf nix-search-tv];
  checkPhase = "";
  text = ''
    # Execute the script from the store path at runtime prevents IFD
    exec "${pkgs.nix-search-tv.src}/nixpkgs.sh" "$@"
  '';
}
