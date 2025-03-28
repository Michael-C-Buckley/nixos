{
  self,
}: let
  pkgs = import self.inputs.nixpkgs {
    system = "x86_64-linux";
  };

  commonNixBuildInputs = with pkgs; [
    self.checks.x86_64-linux.pre-commit-check.enabledPackages
    ragenix
    trufflehog
    alejandra
    nil
    git
    tig
    nixd
    direnv
  ];
in {
  default = self.devShells.x86_64-linux.nixos;
  nixos = pkgs.mkShell {
    inherit (self.checks.x86_64-linux.pre-commit-check) shellHook;
    buildInputs = commonNixBuildInputs;
    env = {
      TRUFFLEHOG_NO_UPDATE = "1";
    };
  };
  nixosServers = pkgs.mkShell {
    inherit (self.checks.x86_64-linux.pre-commit-check) shellHook;
    buildInputs = with pkgs;
      [
        ansible
        ansible-lint
        ansible-language-server
        molecule # Ansible testing framework
      ]
      ++ commonNixBuildInputs;
  };
}
