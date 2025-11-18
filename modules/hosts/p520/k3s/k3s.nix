# Nix-related elements for K3s
{config, ...}: {
  flake.modules.nixos.p520 = {
    imports = [
      config.flake.modules.nixos.k3s
    ];

    custom.impermanence = {
      persist.directories = [
        "/var/lib/forgejo"
      ];
    };
  };
}
