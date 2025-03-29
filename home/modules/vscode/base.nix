# Single list item for imports later into Hjem/Home-managed configs

{pkgs, plugins}: 
[
  (pkgs.vscode-with-extensions.override {
    vscodeExtensions = with pkgs.vscode-extensions; [
      # Microsoft
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-ssh-edit
      ms-vscode-remote.remote-containers
      ms-vsliveshare.vsliveshare
      
      vscode-icons-team.vscode-icons
      mechatroner.rainbow-csv
      streetsidesoftware.code-spell-checker
      formulahendry.auto-rename-tag # Matches XML tags while editing
      alefragnani.bookmarks

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
      plugins.wicked-labs.wvsc-serendipity
      plugins.robbowen.synthwave-vscode
      plugins.eliverlara.andromeda

      # Python
      ms-python.python
      ms-python.vscode-pylance
      ms-pyright.pyright
      ms-python.debugpy

      # Nix
      bbenoist.nix

      # Rust
      rust-lang.rust-analyzer

      # Go
      golang.go

      # Elixir
      elixir-lsp.vscode-elixir-ls

      # Networking
      plugins.jamiewoodio.cisco
      plugins.ispapp.mikrotik-routeros-script-tools
    ];
  })
]