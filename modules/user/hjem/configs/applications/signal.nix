{
  flake.hjemConfigs.signal = {pkgs, ...}: {
    hjem.users.michael = {
      packages = [pkgs.signal-desktop];

      impermanence = {
        persist.directories = [".config/Signal"];
        # cache.directories = [];
      };
    };
  };
}
