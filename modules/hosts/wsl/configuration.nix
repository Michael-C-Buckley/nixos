{inputs, ...}: {
  flake.modules.nixos.wsl = {
    imports = with inputs.self.modules.nixos;
      [
        linuxPreset
        network
        users
        gpg-yubikey
        hjem-default
        hjem-root
        unbound
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

    services.unbound.enable = true;
    system.stateVersion = "24.11";
  };
}
