# Modules to support vscode by adding dependencies to the path list
# This is required since FHS wrapper does not work
# I use vscode sync setting for portability, so add them globally for now
{
  flake.modules.darwin.vscode = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      neovim

      python313
      uv

      nil
      nixd
      sops

      go
      gopls
      delve
      go-tools
      golangci-lint
    ];
  };
}
