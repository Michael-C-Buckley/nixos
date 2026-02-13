{config, ...}: let
  inherit (config.flake) modules;
  inherit (config.flake.hjemConfigs) nixos root extended;
in {
  flake.modules.nixos.desktopPreset = {pkgs, ...}: {
    imports = with modules.nixos; [
      linuxPreset
      shawn
      zfs

      # Network
      network
      dnscrypt-proxy

      # Virtualization
      libvirt

      # Userspace
      chromiumPolicies
      dconf
      hyprland
      tuigreet
      noctalia
      niri

      # Security
      yubikey
      tpm2
      pam-ssh
      secrets
      tailscale

      packages
      packages-desktop
      packages-development
      packages-network
      packages-fonts

      # Users
      michael-attic
      michael-fish
      michael-ssh-agent

      # Hjem
      nixos
      root
      extended
    ];

    environment.systemPackages = with pkgs; [
      yubioath-flutter
      npins
    ];

    # MicroVM Devbox
    custom.impermanence.cache.directories = ["/var/lib/microvms"];

    # Host bridge configuration
    networking = {
      bridges.br0.interfaces = [];
      interfaces.br0 = {
        ipv4.addresses = [
          {
            # Non-routable within my network, local to the host-only
            address = "192.168.254.193";
            prefixLength = 26;
          }
        ];
        ipv6.addresses = [
          {
            address = "fe80::1";
            prefixLength = 64;
          }
        ];
      };
    };
  };
}
