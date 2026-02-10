{config, ...}: {
  flake.modules.nixos.b550 = {pkgs, ...}: {
    imports = with config.flake.modules.nixos; [
      systemd-boot
      impermanence
      serverPreset
      homelabPreset
      network-no-static-default
      containerlab
      lab-network
      libvirt
      attic
      systemd-credentials
      secrets-nic-rename
      tailscale
    ];

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
