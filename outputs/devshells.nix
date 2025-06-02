{self}: let
  inherit (self.inputs) nixpkgs;
  systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
  forAllSystems = nixpkgs.lib.genAttrs systems;
  pkgsForSystem = system:
    import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
in
  forAllSystems (system: let
    pkgs = pkgsForSystem system;
  in {
    default = self.devShells.${system}.nixos;

    nixos = pkgs.mkShell {
      shellHook = ''
        lefthook install

        if [ -d .git ]; then
          git fetch
          git status --short --branch
        fi
      '';
      buildInputs = with pkgs; [
        git
        tig
        commitlint-rs
        editorconfig-checker
        jsonfmt
        lefthook
        mdformat
        treefmt
        taplo

        # Nix
        alejandra
        statix
        deadnix

        # Security
        rage
        sops
        ssh-to-pgp
        ssh-to-age
        trufflehog

        # Yaml
        actionlint
        yamlfmt
      ];
    };
  })
