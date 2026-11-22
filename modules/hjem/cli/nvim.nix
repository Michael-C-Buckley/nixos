{ configPaths, pkgs, ... }:
let
  nvim = pkgs.callPackage ../../../packages/nvim { inherit configPaths; };
  python = pkgs.python3.withPackages (ps: [
    ps.debugpy
    ps.pytest
  ]);
in
{
  imports = [ ../runtime.nix ];

  packages = [
    nvim
    python
  ]
  ++ (with pkgs; [
    lua-language-server
    nil
    nixfmt
    ruff
    zuban
    gopls
    bash-language-server
    yaml-language-server
    vscode-langservers-extracted
    nushell
    fd
    ripgrep
    git
    lazygit
    uv
  ]);
}
