{self, ...}: {
  flake.modules.nixos.hjem-vscode = {pkgs, ...}: {
    custom.impermanence.persist.user.directories = [
      ".config/Code"
      ".vscode"
    ];

    hjem.users.michael.packages = [
      self.packages.${pkgs.system}.vscode
    ];
  };
}
