{config, ...}: {
  flake.modules.nixos.b550 = {pkgs, ...}: {
    imports = with config.flake.modules.nixos; [
      serverPreset
      homelabPreset
      network-no-static-default
      containerlab
      libvirt
      netbird
      attic
    ];

    nix.settings.substituters = ["http://p520:5000"];
    system.stateVersion = "26.05";

    environment = {
      systemPackages = with pkgs; [
        attic-client
      ];

      # Containers (existing data but current disabled)
      persistence."/cache".directories = [
        "/var/lib/containers"
        "/var/tmp"
      ];
    };
  };
}
