{
  flake.hjemConfigs.librewolf = {pkgs, ...}: {
    hjem.users.michael = {
      packages = [pkgs.librewolf];

      impermanence = {
        persist.directories = [".librewolf"];
        cache.directories = [".cache/librewolf"];
      };
    };
  };
}
