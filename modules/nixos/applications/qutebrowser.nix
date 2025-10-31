{
  flake.modules.nixos.app-qutebrowser = {pkgs, ...}: {
    environment.systemPackages = [pkgs.qutebrowser];
    custom.impermanence = {
      persist.user.directories = [
        ".config/qutebrowser"
        ".local/share/qutebrowser"
      ];
      cache.user.directories = [
        ".cache/qutebrowser"
      ];
    };
  };
}
