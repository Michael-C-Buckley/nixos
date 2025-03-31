{
  self,
  pkgs,
}: let
  commonNixBuildInputs = with pkgs; [
    self.checks.x86_64-linux.pre-commit-check.enabledPackages
    # Editing
    alejandra
    nil
    git
    tig
    nixd

    # Security
    trufflehog
    rage
    ragenix
    sops
    ssh-to-pgp
    ssh-to-age
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
