{inputs, ...}: {
  perSystem = {
    self',
    pkgs,
    ...
  }: let
    # Allow unfree and extend with the extensions overlay
    pkgs' =
      (import inputs.nixpkgs {
        inherit (pkgs) system;
        config.allowUnfree = true;
      }).extend
      inputs.nix-vscode-extensions.overlays.default;

    name = "code";
    wrappedInputs = import ./_build-inputs.nix {inherit self' pkgs';};
  in {
    packages.vscode = pkgs.symlinkJoin {
      inherit name;
      paths = [
        (pkgs'.vscode-with-extensions.override {
          vscodeExtensions = import ./_extensions.nix {inherit pkgs';};
        })
      ];
      buildInputs = wrappedInputs;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/${name} \
        --prefix PATH : ${pkgs.lib.makeBinPath wrappedInputs}
      '';
    };
  };
}
