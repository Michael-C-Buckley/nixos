{inputs, ...}: {
  perSystem = {
    self',
    pkgs,
    ...
  }: let
    pkgs' =
      (import inputs.nixpkgs {
        inherit (pkgs) system;
        config.allowUnfree = true;
      }).extend
      inputs.nix-vscode-extensions.overlays.default;

    wrappedInputs = import ./_build-inputs.nix {inherit self' pkgs';};

    vscodeExtensions = import ./_extensions.nix {inherit pkgs';};

    mkVscode = {
      name,
      vscode,
    }:
      pkgs.symlinkJoin {
        inherit name;
        paths = [
          (pkgs'.vscode-with-extensions.override {
            inherit vscode vscodeExtensions;
          })
        ];
        buildInputs = wrappedInputs;
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/${name} \
          --prefix PATH : ${pkgs.lib.makeBinPath wrappedInputs}
        '';
      };
  in {
    packages = {
      vscodium = mkVscode {
        name = "codium";
        vscode = pkgs.vscodium;
      };

      # Only because GHCP still doesn't work yet
      vscode = mkVscode {
        name = "code";
        inherit (pkgs') vscode;
      };
    };
  };
}
