{ pkgs, ... }:
let
  python = pkgs.python3.withPackages (ps: [
    ps.debugpy
    ps.pytest
  ]);
in
{
  imports = [ ../runtime.nix ];

  packages = [
    pkgs.localNvim
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
