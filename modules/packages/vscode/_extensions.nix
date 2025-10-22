{pkgs'}:
with pkgs'.vscode-marketplace-release; [
  # Microsoft Official Only
  ms-vscode-remote.remote-ssh-edit
  ms-python.vscode-pylance

  # AI Tools
  github.copilot
  github.copilot-chat

  # QOL/usability
  mechatroner.rainbow-csv
  streetsidesoftware.code-spell-checker
  oderwat.indent-rainbow
  mkhl.direnv
  asvetliakov.vscode-neovim

  # Language
  ms-python.python
  ms-python.debugpy
  golang.go
  bbenoist.nix

  # Themes
  metaphore.kanagawa-vscode-color-theme
  ddiu8081.moegi-theme
  teabyii.ayu
  enkia.tokyo-night
]
# Extensions I am not currently using
#srl-labs.vscode-containerlab
#redhat.vscode-yaml
#redhat.ansible
#ms-kubernetes-tools.vscode-kubernetes-tools

