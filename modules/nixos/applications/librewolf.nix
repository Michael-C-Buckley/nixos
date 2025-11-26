{
  flake.modules.nixos.app-librewolf = {pkgs, ...}: {
    environment.systemPackages = [pkgs.librewolf-bin];

    custom.impermanence = {
      persist.user.directories = [".librewolf"];
      cache.user.directories = [".cache/librewolf"];
    };
  };
}
