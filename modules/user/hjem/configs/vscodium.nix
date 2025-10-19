{self, ...}: {
  flake.modules.nixos.hjem-vscodium = {pkgs, ...}: let
    inherit (self.packages.${pkgs.system}) vscodium vscode;
  in {
    custom.impermanence.persist.user.directories = [
      ".config/VSCodium"
      ".vscode-oss"
      # Vscode
      ".config/Code"
      ".vscode"
    ];

    hjem.users.michael.packages = [
      vscodium
      vscode
    ];
  };
}
