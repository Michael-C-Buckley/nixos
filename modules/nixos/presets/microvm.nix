{
  config,
  inputs,
  ...
}: let
  inherit (config.flake) modules nixosConfigurations;
in {
  flake.modules.nixos.microvmPreset = {config, ...}: {
    imports = with modules.nixos;
      [
        linuxPreset
      ]
      ++ [
        inputs.microvm.nixosModules.microvm
        inputs.nix-secrets.nixosModules.michael
      ];

    microvm = {
      hypervisor = "qemu";
      socket = "control.socket";
      qemu.extraArgs = [
        "-cpu"
        "host"
        "-smp"
        (toString config.microvm.vcpu)
      ];

      shares = [
        {
          proto = "virtiofs";
          tag = "ro-store";
          source = "/nix/store";
          mountPoint = "/nix/.ro-store";
        }
      ];
    };

    networking = {
      useNetworkd = true;

      nameservers = with config.networking; [
        defaultGateway.address
        defaultGateway6.address
      ];
    };

    services.openssh.enable = true;

    system = {
      # Track my main systems, to which my desktop would be good
      inherit (nixosConfigurations.x570.config.system) stateVersion;
    };
  };
}
