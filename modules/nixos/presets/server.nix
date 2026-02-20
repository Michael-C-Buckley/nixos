{config, ...}: let
  inherit (config.flake) modules;
  inherit (config.flake.hjemConfigs) nixos root;
in {
  flake.modules.nixos.serverPreset = {pkgs, ...}: {
    imports = with modules.nixos; [
      linuxPreset
      network
      zfs
      shawn

      # Security
      clamav
      yubikey
      secrets
      pam-ssh

      # Users
      michael-attic
      michael-nushell

      # Hjem
      nixos
      root

      packages
      packages-network
    ];

    environment.systemPackages = [
      pkgs.python3
      config.flake.packages.${pkgs.stdenv.hostPlatform.system}.vim
    ];
  };
}
