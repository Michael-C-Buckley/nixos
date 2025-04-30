{self}: let
  systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
in
  builtins.listToAttrs (map (system: let
      pkgs = import self.inputs.nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
      };
    in {
      name = system;
      value = {
        default = self.devShells.${system}.nixos;

        nixos = pkgs.mkShell {
          inherit (self.checks.x86_64-linux.pre-commit-check) shellHook;
          buildInputs = with pkgs; [
            self.checks.x86_64-linux.pre-commit-check.enabledPackages
            # Editing
            alejandra
            git
            tig

            # Security
            trufflehog
            rage
            sops
            ssh-to-pgp
            ssh-to-age
          ];
          env = {
            TRUFFLEHOG_NO_UPDATE = "1";
          };
        };
      };
    })
    systems)
