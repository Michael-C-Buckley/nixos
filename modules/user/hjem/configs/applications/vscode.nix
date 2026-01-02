{config, ...}: {
  flake.hjemConfigs.vscode = {pkgs, ...}: {
    hjem.users.michael = {
      packages = [
        config.flake.packages.${pkgs.stdenv.hostPlatform.system}.vscode
      ];

      impermanence.persist.directories = [
        ".config/Code"
        ".vscode"
      ];
    };
  };
}
