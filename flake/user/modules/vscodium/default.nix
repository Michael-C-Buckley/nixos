{
  pkgs,
  inputs,
  ...
}: let
  wrappedInputs = with pkgs; [
    python313
    basedpyright
    nil
    nixd
    go
    gopls
    pyrefly
    sops
    (import ./nvf.nix {inherit pkgs inputs;})
  ];

  mkVscodePkg = {
    name,
    vscode,
    binaryName,
  }: (
    pkgs.symlinkJoin {
      inherit name;
      paths = [
        (pkgs.vscode-with-extensions.override {
          inherit vscode;
          vscodeExtensions = import ./extensions.nix {inherit pkgs;};
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
  # WIP: Impermanence, since I don't have user impermanence at the moment
  # system.impermanence.userPersistDirs = optionals impermanence.enable [
  #   "/home/michael/.config/VSCodium"
  #   "/home/michael/.vscode-oss/extensions"
  # ];

  # This overlay is only consumed in this module
  nixpkgs.overlays = [inputs.nix4vscode.overlays.forVscode];

  users.users.michael.packages = [
    # For now, ship both, I'll decide which I need when using it
    (mkVscodePkg {
      name = "vscodium-michael";
      vscode = pkgs.vscodium;
      binaryName = "codium";
    })
    (mkVscodePkg {
      name = "vscode-michael";
      inherit (pkgs) vscode;
      binaryName = "code";
    })
  ];
}
