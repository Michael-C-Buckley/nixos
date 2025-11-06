{pkgs'}:
with pkgs'; [
  neovim

  python313
  basedpyright
  nil
  nixd
  pyrefly
  sops

  # Go tools
  go
  gopls
  delve
  go-tools
  golangci-lint
]
