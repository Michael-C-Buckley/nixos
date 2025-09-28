{pkgs}:
with pkgs.vscode-extensions;
  [
    # QOL/usability
    mechatroner.rainbow-csv
    streetsidesoftware.code-spell-checker
    formulahendry.auto-rename-tag # Matches XML tags while editing
    oderwat.indent-rainbow
    mkhl.direnv
    asvetliakov.vscode-neovim

    # DevOps/etc
    redhat.vscode-yaml
    redhat.ansible
    ms-kubernetes-tools.vscode-kubernetes-tools
    signageos.signageos-vscode-sops

    # Themes
    teabyii.ayu
    huytd.nord-light
    arcticicestudio.nord-visual-studio-code
    enkia.tokyo-night
    mvllow.rose-pine
    catppuccin.catppuccin-vsc
    jdinhlife.gruvbox

    # Languages
    ms-python.python
    ms-python.debugpy
    ms-pyright.pyright
    detachhead.basedpyright
    golang.go
    bbenoist.nix
    rust-lang.rust-analyzer
  ]
  ++ pkgs.nix4vscode.forVscode [
    # Themes
    "wicked-labs.wvsc-serendipity"
    "metaphore.kanagawa-vscode-color-theme"
    "ddiu8081.moegi-theme"
    "sainnhe.everforest"
    "subframe7536.theme-maple"

    # Networking tools
    "jamiewoodio.cisco"
    "ispapp.mikrotik-routeros-script-tools"
    "srl-labs.vscode-containerlab"
  ]
  ++ pkgs.nix4vscode.forOpenVsx [
    "jeanp413.open-remote-ssh"
  ]
