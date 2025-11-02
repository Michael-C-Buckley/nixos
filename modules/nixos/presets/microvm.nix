{
  config,
  inputs,
  ...
}: {
  flake.modules.nixos.microvmPreset = {
    imports = with config.flake.modules.nixos;
      [
        linuxPreset
        users
      ]
      ++ [
        inputs.microvm.nixosModules.microvm
        inputs.nix-secrets.nixosModules.michael
      ];

    system = {
      # Track my main systems, to which my desktop would be good
      inherit (config.flake.nixosConfigurations.x570.config.system) stateVersion;
    };
  };
}
