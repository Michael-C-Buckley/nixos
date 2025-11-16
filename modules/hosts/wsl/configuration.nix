{
  inputs,
  config,
  ...
}: let
  inherit (config.flake.modules) nixos nvf;
  inherit (config.flake) hjemConfig;
in {
  flake.modules.nixos.wsl = {
    imports = with nixos;
      [
        linuxPreset
        network
        users
        gpg-yubikey
        hjemConfig.wsl
        hjemConfig.root
        hjemConfig.gpgAgent
        dnscrypt-proxy
        packages
        packages-development
        packages-network
        app-opencode
      ]
      ++ [
        inputs.nixos-wsl.nixosModules.default
      ];

    networking = {
      hostName = "wsl";
      hostId = "e07f0101";
      nameservers = [
        "::1"
        "127.0.0.1"
        "1.1.1.1"
        "9.9.9.9"
      ];
      networkmanager = {
        enable = true;
        unmanaged = ["*"];
      };
    };

    programs = {
      nix-ld.enable = true; # Allows seamless vscode WSL (and also remote) to just work
      nvf.settings.imports = [nvf.extended];
    };

    system.stateVersion = "24.11";
  };
}
