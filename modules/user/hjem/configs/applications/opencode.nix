{config, ...}: {
  flake.hjemConfigs.opencode = {pkgs, ...}: {
    hjem.users.michael = {
      packages = [
        config.flake.packages.${pkgs.stdenv.hostPlatform.system}.opencode
      ];

      impermanence = {
        persist.directories = [".config/opencode"];
        cache.directories = [
          ".cache/opencode"
          ".local/share/opencode"
        ];
      };
    };
  };
}
