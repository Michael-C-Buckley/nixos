{
  flake.hjemConfigs.element = {pkgs, ...}: {
    hjem.users.michael = {
      packages = [pkgs.element-desktop];

      impermanence = {
        persist.directories = [
          ".config/Element"
          ".local/share/Element"
        ];
      };
    };
  };
}
