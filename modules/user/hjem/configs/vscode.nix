{self, ...}: {
  flake.modules.nixos.hjem-vscodium = {pkgs, ...}: let
    inherit (self.packages.${pkgs.system}) vscode;
  in {
    custom.impermanence.persist.user.directories = [
      # Vscodium
      #".config/VSCodium"
      #".vscode-oss"

      # Vscode
      ".config/Code"
      ".vscode"
    ];

    hjem.users.michael.packages = [
      #vscodium
      vscode
    ];
  };
}
