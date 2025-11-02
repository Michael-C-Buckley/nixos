{config, ...}: let
  inherit (config.flake.modules) nixos;
  interface = "enp0s2";
  projectDir = "/home/michael/projects/devbox";
  mac = "02:00:00:00:00:01";
in {
  flake.modules.nixos.devbox = {
    config,
    pkgs,
    ...
  }: {
    imports = with nixos; [
      microvmPreset
      hjem-default
      hjem-root
      packages
      packages-server
    ];

    microvm = {
      hypervisor = "qemu";
      socket = "control.socket";
      vcpu = 4;
      mem = 8192;

      qemu.extraArgs = [
        "-cpu"
        "host"
        "-smp"
        "${toString config.microvm.vcpu}"
      ];

      interfaces = [
        {
          type = "tap";
          id = "vm-devbox";
          inherit mac;
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

    systemd.network.links."20-eth0" = {
      matchConfig.MACAddress = mac;
      linkConfig.Name = "eth0";
    };

    networking = {
      firewall.enable = false;
      hostName = "devbox";
      useNetworkd = true;

      nameservers = with config.networking; [
        defaultGateway.address
        defaultGateway6.address
      ];

      # Configure static networking for simplicity
      defaultGateway = {
        address = "192.168.254.254";
        inherit interface;
      };
      defaultGateway6 = {
        address = "fe80::1";
        inherit interface;
      };

      interfaces.eth0 = {
        ipv4.addresses = [
          {
            address = "192.168.254.255";
            prefixLength = 31;
          }
        ];
        ipv6.addresses = [
          {
            address = "fe80::100";
            prefixLength = 64;
          }
        ];
      };
    };

    # AI tools
    environment.systemPackages = with pkgs; [
      goose-cli
      gemini-cli
      github-copilot-cli
    ];

    services.openssh.enable = true;
    boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
  };
}
