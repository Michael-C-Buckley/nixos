{
  flake.modules.nixos.app-signal = {pkgs, ...}: {
    environment.systemPackages = [pkgs.signal-desktop];

    custom.impermanence = {
      persist.user.directories = [".config/Signal"];
      # cache.user.directories = [];
    };
  };
}
