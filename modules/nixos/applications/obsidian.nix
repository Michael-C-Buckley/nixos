{
  flake.modules.nixos.app-obsidian = {pkgs, ...}: {
    environment.systemPackages = [pkgs.obsidian];
    custom.impermanence.persist.user.directories = [".config/obsidian"];
  };
}
