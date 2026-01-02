{config, ...}: {
  flake.hjemConfigs.helium = {pkgs, ...}: {
    hjem.users.michael = {
      packages = [config.flake.packages.${pkgs.stdenv.hostPlatform.system}.helium];

      impermanence = {
        persist.directories = [".config/net.imput.helium"];
        cache.directories = [".cache/net.imput.helium"];
      };
    };
  };
}
