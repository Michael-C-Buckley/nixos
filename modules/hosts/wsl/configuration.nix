{
  inputs,
  config,
  ...
}: {
  flake.modules.nixos.wsl = {
    imports = with config.flake.modules.nixos;
      [
        linuxPreset
        network
        users
        gpg-yubikey
        hjem-wsl
        hjem-root
        unbound
        packages
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

    programs.nix-ld.enable = true;

    system.stateVersion = "24.11";
  };
}
