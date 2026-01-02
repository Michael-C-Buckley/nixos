{
  flake.hjemConfigs.novelwriter = {pkgs, ...}: {
    hjem.users.michael = {
      packages = [pkgs.novelwriter];

      impermanence = {
        persist.directories = [
          ".config/novelwriter"
          ".local/share/novelwriter"
        ];
        cache.directories = [".cache/novelwriter"];
      };
    };
  };
}
