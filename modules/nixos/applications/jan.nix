{
  flake.modules.nixos.app-jan = {pkgs, ...}: {
    custom.impermanence.persist.user.directories = [
      ".local/share/Jan"
      ".local/share/jan/ai/app"
    ];

    environment.systemPackages = [pkgs.jan];
  };
}
