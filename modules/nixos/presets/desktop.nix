{config, ...}: let
  inherit (config.flake) modules;
  inherit (config.flake.hjemConfigs) nixos root extended;
in {
  flake.modules.nixos.desktopPreset = {
    imports = with modules.nixos; [
      linuxPreset
      shawn
      zfs

      # Network
      network
      dnscrypt-proxy

      # Virtualization
      libvirt
      containerlab

      # Userspace
      chromiumPolicies
      dconf
      hyprland
      greetd
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
      michael-nushell
      michael-ssh-agent

      # Hjem
      nixos
      root
      extended
    ];

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
