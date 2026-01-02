{
  flake.hjemModules.materialgram = {pkgs, ...}: {
    packages = [pkgs.materialgram];

    impermanence = {
      persist.directories = [".local/share/materialgram"];
      # cache.directories = [];
    };
  };
}
