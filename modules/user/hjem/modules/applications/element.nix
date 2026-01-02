{
  flake.hjemModules.element = {pkgs, ...}: {
    packages = [pkgs.element-desktop];

    impermanence = {
      persist.directories = [
        ".config/Element"
        ".local/share/Element"
      ];
    };
  };
}
