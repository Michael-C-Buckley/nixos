{
  flake.modules.nixos.app-novelwriter = {pkgs, ...}: {
    custom.impermanence = {
      persist.user.directories = [
        ".config/novelwriter"
        ".local/share/novelwriter"
      ];
      cache.user.directories = [".cache/novelwriter"];
    };

    environment.systemPackages = [pkgs.novelwriter];
  };
}
