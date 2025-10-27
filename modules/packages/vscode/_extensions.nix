{pkgs'}:
with pkgs'.vscode-marketplace-release; [
  # Microsoft Official Only
  ms-vscode-remote.remote-ssh-edit
  ms-python.vscode-pylance

  # Devops
  ms-kubernetes-tools.vscode-kubernetes-tools

  # AI Tools
  github.copilot
  github.copilot-chat

  # QOL/usability
  mkhl.direnv
  asvetliakov.vscode-neovim

  # Language
  ms-python.python
  ms-python.debugpy
  golang.go
  bbenoist.nix

  # Themes
  ms-vscode.theme-predawnkit
  github.github-vscode-theme
  yummygum.city-lights-theme
  teabyii.ayu
]
# Extensions I am not currently using
#srl-labs.vscode-containerlab
#redhat.vscode-yaml
#redhat.ansible

