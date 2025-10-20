{pkgs'}:
with pkgs'.vscode-marketplace-release;
  [
    # AI Tools
    github.copilot
    github.copilot-chat
    rjmacarthy.twinny

    # QOL/usability
    mechatroner.rainbow-csv
    streetsidesoftware.code-spell-checker
    formulahendry.auto-rename-tag # Matches XML tags while editing
    oderwat.indent-rainbow
    mkhl.direnv
    asvetliakov.vscode-neovim

    # Language
    ms-python.python
    ms-python.debugpy
    ms-pyright.pyright
    detachhead.basedpyright
    meta.pyrefly
    golang.go
    bbenoist.nix
    rust-lang.rust-analyzer

    # Utility
    signageos.signageos-vscode-sops

    # Themes
    wicked-labs.wvsc-serendipity
    metaphore.kanagawa-vscode-color-theme
    ddiu8081.moegi-theme
    ddiu8081.moegi-theme
    teabyii.ayu
    huytd.nord-light
    arcticicestudio.nord-visual-studio-code
    enkia.tokyo-night
    mvllow.rose-pine
    catppuccin.catppuccin-vsc
    jdinhlife.gruvbox
  ]
  ++ [
    # Open Remote
    pkgs'.open-vsx-release.jeanp413.open-remote-ssh
  ]
# Extensions I am not currently using, but have
# Networking tools
#"jamiewoodio.cisco"
#"ispapp.mikrotik-routeros-script-tools"
#"srl-labs.vscode-containerlab"
#
# DevOps/etc
#redhat.vscode-yaml
#redhat.ansible
#ms-kubernetes-tools.vscode-kubernetes-tools

