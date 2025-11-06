{inputs, ...}: {
  perSystem = {pkgs, ...}: let
    # Allow unfree and extend with the extensions overlay
    pkgs' =
      (import inputs.nixpkgs {
        inherit (pkgs) system;
        config.allowUnfree = true;
      }).extend
      inputs.nix-vscode-extensions.overlays.default;

    # These are placed in the path of the program
    wrappedInputs = with pkgs'; [
      neovim

      python313
      basedpyright
      nil
      nixd
      pyrefly
      sops

      go
      gopls
      delve
      go-tools
      golangci-lint
    ];

    vscodeExtensions = with pkgs'.vscode-marketplace-release; [
      # Microsoft Official
      ms-vscode-remote.remote-ssh-edit
      ms-python.vscode-pylance
      ms-vsliveshare.vsliveshare
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
    ];
  in {
    packages.vscode = pkgs.symlinkJoin {
      name = "code";
      paths = [
        (pkgs'.vscode-with-extensions.override {
          inherit vscodeExtensions;
        })
      ];
      buildInputs = wrappedInputs;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/code \
        --prefix PATH : ${pkgs.lib.makeBinPath wrappedInputs}
      '';
    };
  };
}
