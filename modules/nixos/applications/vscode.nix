{config, ...}: {
  flake.modules.nixos.app-vscode = {pkgs, ...}: {
    custom.impermanence.persist.user.directories = [
      ".config/Code"
      ".vscode"
    ];

    hjem.users.michael.packages = [
      config.flake.packages.${pkgs.stdenv.hostPlatform.system}.vscode
    ];
  };
}
