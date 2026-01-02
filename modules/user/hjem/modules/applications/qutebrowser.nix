{
  flake.hjemModules.qutebrowser = {pkgs, ...}: {
    packages = [pkgs.qutebrowser];

    impermanence = {
      persist.directories = [
        ".config/qutebrowser"
        ".local/share/qutebrowser"
      ];
      cache.directories = [".cache/qutebrowser"];
    };
  };
}
