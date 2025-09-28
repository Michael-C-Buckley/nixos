{pkgs}: let
  vscodeExtensions = with pkgs.vscode-extensions; [
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
  ];

  vscodiumPkg = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscodium;
    inherit vscodeExtensions;
  };

  wrappedInputs = with pkgs; [
    python313
    nil
    basedpyright
    neovim
  ];
in
  pkgs.symlinkJoin {
    name = "vscodium-michael";
    paths = [vscodiumPkg];
    buildInputs = wrappedInputs;
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/codium \
      --prefix PATH : ${pkgs.lib.makeBinPath wrappedInputs}
    '';
  }
