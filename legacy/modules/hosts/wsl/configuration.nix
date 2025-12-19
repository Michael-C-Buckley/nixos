{
  inputs,
  config,
  ...
}: let
  inherit (config.flake) modules;
  inherit (config.flake) hjemConfig;
in {
  flake.modules.nixos.wsl = {
    imports = with modules.nixos;
      [
        linuxPreset
        network
        yubikey
        dnscrypt-proxy
        packages
        packages-development
        packages-network
        app-opencode
      ]
      ++ (with hjemConfig; [
        nixos
        root
        gpgAgent
        cursor
        helix
      ])
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
      nvf.settings.imports = [modules.nvf.extended];
    };

    security.sudo.wheelNeedsPassword = false;

    system.stateVersion = "24.11";
  };
}
