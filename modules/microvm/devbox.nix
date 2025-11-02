{config, ...}: let
  interface = "enp0s2";
  projectDir = "/home/michael/projects/devbox";
in {
  flake.modules.nixos.devbox = {pkgs, ...}: {
    imports = with config.flake.modules.nixos; [
      microvmPreset
      hjem-default
      hjem-root
      packages
      packages-server
    ];

    microvm = {
      hypervisor = "crosvm";
      socket = "control.socket";
      vcpu = 4;
      mem = 8192;

      interfaces = [
        {
          type = "tap";
          id = "vm-devbox";
          mac = "02:00:00:00:00:01";
        }
      ];

      shares = [
        {
          proto = "virtiofs";
          tag = "ro-store";
          source = "/nix/store";
          mountPoint = "/nix/.ro-store";
        }
        {
          proto = "virtiofs";
          tag = "devbox";
          source = projectDir;
          mountPoint = projectDir;
        }
      ];
    };

    networking = {
      firewall.enable = false;
      hostName = "devbox";

      # Configure static networking for simplicity
      defaultGateway = {
        address = "192.168.254.254";
        inherit interface;
      };
      defaultGateway6 = {
        address = "fe80::1";
        inherit interface;
      };

      interfaces.enp0s2 = {
        ipv4 = {
          addresses = [
            {
              address = "192.168.254.255";
              prefixLength = 31;
            }
          ];
        };
      };
    };

    # AI tools
    environment.systemPackages = with pkgs; [
      goose-cli
      gemini-cli
      github-copilot-cli
      #claude-code
    ];

    services.openssh.enable = true;
  };
}
