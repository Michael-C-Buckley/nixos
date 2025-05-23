{config, pkgs, ...}: {
  hjem.users.michael.apps.editors.vscode = {
    enable = config.features.michael.extendedGraphical;
    extensions = with pkgs.vscode-extensions; [
      # Microsoft
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-ssh-edit
      ms-vscode-remote.remote-containers
      ms-vsliveshare.vsliveshare

      vscode-icons-team.vscode-icons
      mechatroner.rainbow-csv
      streetsidesoftware.code-spell-checker
      formulahendry.auto-rename-tag # Matches XML tags while editing
      oderwat.indent-rainbow

      # Kubernetes
      ms-kubernetes-tools.vscode-kubernetes-tools

      # Ansible
      redhat.ansible
      redhat.vscode-yaml

      # Themes
      teabyii.ayu
      huytd.nord-light
      arcticicestudio.nord-visual-studio-code
      enkia.tokyo-night
      mvllow.rose-pine
      catppuccin.catppuccin-vsc
      jdinhlife.gruvbox

      # Python
      ms-python.python
      ms-python.vscode-pylance
      ms-python.debugpy

      # Nix
      bbenoist.nix

      # Rust
      rust-lang.rust-analyzer

      # Go
      golang.go

      # Elixir
      elixir-lsp.vscode-elixir-ls
    ];
    nonNixExtensions = [
      # Themes
      "wicked-labs.wvsc-serendipity"
      "keifererikson.nightfox"
      "metaphore.kanagawa-vscode-color-theme"
      "ddiu8081.moegi-theme"
      "sainnhe.everforest"

      # Editor Tools
      "AlecGhost.tree-sitter-vscode"

      # Networking Tools
      "jamiewoodio.cisco"
      "ispapp.mikrotik-routeros-script-tools"
      "srl-labs.vscode-containerlab"
    ];
  };
}
