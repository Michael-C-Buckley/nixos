{
  flake.modules.nixos.app-element = {pkgs, ...}: {
    users.users.michael.packages = [pkgs.element-desktop];

    custom.impermanence = {
      persist.user.directories = [
        ".config/Element"
        ".local/share/Element"
      ];
    };
  };
}
