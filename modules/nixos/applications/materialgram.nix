{
  flake.modules.nixos.app-materialgram = {pkgs, ...}: {
    environment.systemPackages = [pkgs.materialgram];

    custom.impermanence = {
      persist.user.directories = [".local/share/materialgram"];
      # cache.user.directories = [];
    };
  };
}
