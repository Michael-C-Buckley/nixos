{
  flake.hjemConfigs.materialgram = {pkgs, ...}: {
    hjem.users.michael = {
      packages = [pkgs.materialgram];

      impermanence = {
        persist.directories = [".local/share/materialgram"];
        # cache.directories = [];
      };
    };
  };
}
