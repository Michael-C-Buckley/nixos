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
      inherit (self.checks.${system}.pre-commit-check) shellHook;
      buildInputs = with pkgs; [
        self.checks.${system}.pre-commit-check.enabledPackages
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
  })