{
  flake.modules.nixos.app-librewolf = {pkgs, ...}: {
    environment.systemPackages = [pkgs.librewolf];

    custom.impermanence = {
      persist.user.directories = [".librewolf"];
      cache.user.directories = [".cache/librewolf"];
    };
  };
}
