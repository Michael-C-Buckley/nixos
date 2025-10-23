{
  nvf-vscode,
  pkgs',
}:
with pkgs';
  [
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
  ++ [
    nvf-vscode
  ]
