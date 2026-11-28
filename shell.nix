{ pkgs }:
let
  shellEnv = pkgs.buildEnv {
    name = "flake-shell-env";
    pathsToLink = [ "/bin" ];
    paths = with pkgs; [
      (pkgs.localTack or tack)
      deadnix
      lefthook
      mdformat
      nil
      nixfmt
      selene
      shellcheck-minimal
      statix
      stylua
      taplo
      treefmt
      typos
      yamllint
    ];
  };
in

pkgs.mkShellNoCC {
  packages = [ shellEnv ];
  shellHook = ''
    if [ -f .config/lefthook.toml ] && git rev-parse --show-toplevel >/dev/null 2>&1 &&
      ! lefthook check-install >/dev/null 2>&1; then
      lefthook install
    fi
  '';
}
