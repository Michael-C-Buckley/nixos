{self, ...}: {
  flake.modules.nixos.app-vscode = {pkgs, ...}: {
    custom.impermanence.persist.user.directories = [
      ".config/Code"
      ".vscode"
    ];

    environment.systemPackages = [
      self.packages.${pkgs.system}.vscode
    ];
  };
}
