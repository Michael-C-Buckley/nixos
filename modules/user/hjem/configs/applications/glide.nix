{config, ...}: {
  flake.hjemConfigs.glide = {pkgs, ...}: {
    hjem.users.michael = {
      packages = [config.flake.packages.${pkgs.stdenv.hostPlatform.system}.glide];

      impermanence = {
        persist.directories = [
          ".config/glide"
        ];
        cache.directories = [
          ".cache/glide"
          ".config/mozilla/glide"
        ];
      };
    };
  };
}
