{ lib, ... }:
{
  imports = [
    ./modules/boot.nix
    ./modules/hardware.nix
    ./nixos/hardware.nix
    ./nixos/network.nix
    ./nixos/night-led.nix
  ];

  hjem.users.michael.imports = [ ./hjem/desktop.nix ];

  services.greetd.settings.initial_session = {
    user = "michael";
    command = "start-hyprland";
  };

  users.users.michael.uid = 1000;

  nix.settings = {
    experimental-features = lib.mkAfter [ "read-only-local-store" ];
    # Trust only the other local installation's unsigned builds for now.
    extra-substituters = [
      "local?root=/var/lib/machines/finix&read-only=true&trusted=true&priority=10"
    ];
    always-allow-substitutes = true;
  };

  systemd.services.nix-daemon.unitConfig.RequiresMountsFor = [
    "/var/lib/machines/finix/nix"
  ];
}
