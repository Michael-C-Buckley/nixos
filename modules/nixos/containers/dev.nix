{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.devSpawn = {config, ...}: {
    containers.dev = {
      autoStart = true;
      specialArgs = {
        inherit flake;
        parentConfig = config;
      };

      privateNetwork = true;
      hostBridge = "br0";
      ephemeral = true;

      bindMounts = {
        "/home/michael/projects" = {
          hostPath = "/home/michael/projects";
          isReadOnly = false;
        };
      };

      config = {
        pkgs,
        flake,
        parentConfig,
        ...
      }: {
        imports = with flake.modules.nixos; [
          hjem-default
          users
          packages
        ];

        system = {
          inherit (parentConfig.system) stateVersion;
        };

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

        environment.systemPackages = with pkgs; [
          neovim
          goose-cli
          copilot-cli
          gemini-cli
          opencode
          amp-cli
        ];
      };
    };
  };
}
