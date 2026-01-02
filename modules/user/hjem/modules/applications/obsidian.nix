{
  flake.hjemModules.obsidian = {pkgs, ...}: {
    packages = [pkgs.obsidian];

    impermanence.persist.directories = [".config/obsidian"];
  };
}
