{
  flake.hjemConfigs.obsidian = {pkgs, ...}: {
    hjem.users.michael = {
      packages = [pkgs.obsidian];

      impermanence.persist.directories = [".config/obsidian"];
    };
  };
}
