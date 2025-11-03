{config, ...}: {
  flake.modules.nixos.devSpawn = {
    containers.dev = {
      autoStart = true;
      specialArgs = {inherit (config) flake;};

      privateNetwork = true;
      hostBridge = "br0";

      bindMounts = {
        "/home/michael/projects" = {
          hostPath = "/home/michael/projects";
          isReadOnly = false;
        };
      };

      config = {
        pkgs,
        flake,
        ...
      }: {
        networking = {
          nameservers = ["192.168.254.193"];
          defaultGateway = {
            address = "192.168.254.193";
            interface = "eth0";
          };
          interfaces.eth0.ipv4.addresses = [
            {
              address = "192.168.254.200";
              prefixLength = 26;
            }
          ];
        };
        imports = with flake.modules.nixos; [
          hjem-default
          users
          packages
        ];

        environment.systemPackages = with pkgs; [
          neovim
          goose-cli
          copilot-cli
          gemini-cli
        ];
      };
    };
  };
}
