{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
  inherit (pkgs) vscodium-fhs vscode-extensions;
in {
  hjem.users.michael.programs.vscode = {
    enable = mkDefault config.features.michael.extendedGraphical;
    enableRemote = mkDefault true;
    package = mkDefault vscodium-fhs;

    msExtensions = with vscode-extensions; [
      ms-vsliveshare.vsliveshare
    ];

    extensions = with vscode-extensions; [
      mechatroner.rainbow-csv
      streetsidesoftware.code-spell-checker
      formulahendry.auto-rename-tag # Matches XML tags while editing
      oderwat.indent-rainbow

      # Kubernetes
      ms-kubernetes-tools.vscode-kubernetes-tools

      # Ansible
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
    ];
  };
}
# Removed tools (this is for my notes, they can be added via devshells)
# extensions = [
#   rust-lang.rust-analyzer
#   golang.go
#   elixir-lsp.vscode-elixir-ls
#   redhat.ansible
# ]
# nonNixExtensions = [
#   "jamiewoodio.cisco"
#   "ispapp.mikrotik-routeros-script-tools"
#   "srl-labs.vscode-containerlab"
# ]

