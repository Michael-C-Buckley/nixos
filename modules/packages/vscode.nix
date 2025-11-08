{inputs, ...}: {
  perSystem = {pkgs, ...}: let
    # Allow unfree and extend with the extensions overlay
    pkgs' =
      (import inputs.nixpkgs {
        localSystem = pkgs.stdenv.hostPlatform;
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
      # Trusted Sources

      # Microsoft Official
      ms-vscode-remote.remote-ssh-edit
      ms-vscode-remote.remote-ssh
      ms-python.vscode-pylance
      ms-vsliveshare.vsliveshare
      ms-kubernetes-tools.vscode-kubernetes-tools
      ms-toolsai.jupyter
      ms-azuretools.vscode-containers
      ms-vscode-remote.remote-containers

      # Github Tools
      github.copilot
      github.copilot-chat
      github.vscode-github-actions

      # Language
      ms-python.python
      ms-python.debugpy
      redhat.vscode-yaml
      redhat.vscode-xml
      redhat.ansible
      golang.go

      # Themes
      ms-vscode.theme-predawnkit
      github.github-vscode-theme

      sourcegraph.amp

      # Unofficial Sources

      # Themes
      yummygum.city-lights-theme
      teabyii.ayu

      # Languages
      bbenoist.nix

      # QOL/usability
      mkhl.direnv
      asvetliakov.vscode-neovim
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
