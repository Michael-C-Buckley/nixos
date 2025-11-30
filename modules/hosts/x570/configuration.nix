{config, ...}: {
  flake.modules.nixos.x570 = {lib, ...}: {
    imports = with config.flake.modules.nixos; [
      desktopPreset
      intelGraphics
      wifi
      gaming
      k3s
    ];

    nix.settings.substituters = lib.mkBefore ["http://p520:5000"];
    system.stateVersion = "25.05";

    # Containers (existing data but current disabled)
    environment.persistence."/cache".directories = [
      "/var/lib/containers"
      "/var/tmp"
    ];

    hjem.users.michael = {
      files = {
        ".config/sops/age/keys.txt".text = "AGE-PLUGIN-YUBIKEY-1A64Q2Q5ZRRP4GDQ2A95S8";
      };
      rum.programs.git.settings.user.signingkey = "408634D7706AC8085CD41AFFC36327B33A6765A7!";
    };
  };
}
