{
  flake.hjemModules.librewolf = {pkgs, ...}: {
    packages = [pkgs.librewolf];

    impermanence = {
      persist.directories = [".librewolf"];
      cache.directories = [".cache/librewolf"];
    };
  };
}
