{
  pkgs,
  inputs,
  ...
}: let
  vscodeExtensions = with pkgs.vscode-extensions;
    [
      # QOL/usability
      mechatroner.rainbow-csv
      streetsidesoftware.code-spell-checker
      formulahendry.auto-rename-tag # Matches XML tags while editing
      oderwat.indent-rainbow

      # DevOps/etc
      redhat.vscode-yaml
      redhat.ansible
      ms-kubernetes-tools.vscode-kubernetes-tools

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
      ms-python.vscode-pylance
      ms-python.debugpy
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
    ];

  vscodiumPkg = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscodium;
    inherit vscodeExtensions;
  };

  wrappedInputs = with pkgs; [
    python313Packages.jedi-language-server
    python313Packages.pylance
  ];
in {
  # WIP: Impermanence, since I don't have user impermanence at the moment
  # system.impermanence.userPersistDirs = optionals impermanence.enable [
  #   "/home/michael/.config/VSCodium"
  #   "/home/michael/.vscode-oss/extensions"
  # ];

  # This overlay is only consumed in this module
  nixpkgs.overlays = [inputs.nix4vscode.overlays.forVscode];

  users.users.michael.packages = [
    (pkgs.symlinkJoin {
      name = "vscodium-michael";
      paths = [vscodiumPkg];
      buildInputs = wrappedInputs;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/codium \
        --prefix PATH : ${pkgs.lib.makeBinPath wrappedInputs}
      '';
    })
  ];
}
