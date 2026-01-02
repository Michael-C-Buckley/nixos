{
  flake.hjemModules.signal = {pkgs, ...}: {
    packages = [pkgs.signal-desktop];

    impermanence = {
      persist.directories = [".config/Signal"];
      # cache.directories = [];
    };
  };
}
