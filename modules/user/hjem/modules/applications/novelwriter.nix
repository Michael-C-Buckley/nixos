{
  flake.hjemModules.novelwriter = {pkgs, ...}: {
    packages = [pkgs.novelwriter];

    impermanence = {
      persist.directories = [
        ".config/novelwriter"
        ".local/share/novelwriter"
      ];
      cache.directories = [".cache/novelwriter"];
    };
  };
}
