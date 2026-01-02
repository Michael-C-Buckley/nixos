{config, ...}: {
  flake.hjemModules.vscode = {pkgs, ...}: {
    packages = [
      config.flake.packages.${pkgs.stdenv.hostPlatform.system}.vscode
    ];

    impermanence.persist.directories = [
      ".config/Code"
      ".vscode"
    ];
  };
}
