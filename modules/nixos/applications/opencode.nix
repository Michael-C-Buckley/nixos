{config, ...}: {
  flake.modules.nixos.app-opencode = {pkgs, ...}: {
    custom.impermanence = {
      cache.user.directories = [
        ".cache/opencode"
        ".local/share/opencode"
      ];
      persist.user.directories = [
        ".config/opencode"
      ];
    };

    environment.systemPackages = [
      config.flake.packages.${pkgs.stdenv.hostPlatform.system}.opencode
    ];
  };
}
