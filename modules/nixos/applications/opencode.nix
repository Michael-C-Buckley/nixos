{
  flake.modules.nixos.app-opencode = {pkgs, ...}: {
    custom.impermanence.persist.user.directories = [
      ".config/opencode"
      ".cache/opencode"
      ".local/share/opencode"
    ];

    environment.systemPackages = [pkgs.opencode];
  };
}
