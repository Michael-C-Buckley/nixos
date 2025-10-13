{
  pkgs,
  inputs,
  ...
}: let
  wrappedInputs = with pkgs;
    [
      python313
      basedpyright
      nil
      nixd
      pyrefly
      sops

      # Go tools
      go
      gopls
      delve
      go-tools
      golangci-lint
    ]
    ++ [(import ./_nvf.nix {inherit pkgs inputs;})];

  vscodeExt = with pkgs.vscode-marketplace-release; [
    ms-python.vscode-pylance
    ms-vscode-remote.remote-ssh
    github.copilot
    github.copilot-chat
  ];

  vscodiumExt = with pkgs; [
    vscode-marketplace-release.continue.continue
    open-vsx-release.jeanp413.open-remote-ssh
  ];

  mkVscodePkg = {
    name,
    vscode,
    binaryName,
    extraExt ? [],
  }: (
    pkgs.symlinkJoin {
      inherit name;
      paths = [
        (pkgs.vscode-with-extensions.override {
          inherit vscode;
          vscodeExtensions = (import ./_extensions.nix {inherit pkgs;}) ++ extraExt;
        })
      ];
      buildInputs = wrappedInputs;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/${binaryName} \
        --prefix PATH : ${pkgs.lib.makeBinPath wrappedInputs}
      '';
    }
  );
in {
  # This overlay is only consumed in this module
  nixpkgs.overlays = [inputs.nix-vscode-extensions.overlays.default];

  environment.persistence."/persist".users.michael.directories = [
    ".config/VSCodium"
    ".vscode-oss"
    ".config/Code"
    ".vscode"
  ];

  users.users.michael.packages = [
    # For now, ship both, I'll decide which I need when using it
    (mkVscodePkg {
      name = "vscodium-michael";
      vscode = pkgs.vscodium;
      binaryName = "codium";
      extraExt = vscodiumExt;
    })
    (mkVscodePkg {
      name = "vscode-michael";
      inherit (pkgs) vscode;
      binaryName = "code";
      extraExt = vscodeExt;
    })
  ];
}
