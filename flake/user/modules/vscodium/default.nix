{
  pkgs,
  inputs,
  ...
}: let
  vscodiumPkg = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscodium;
    vscodeExtensions = import ./extensions.nix {inherit pkgs;};
  };

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
