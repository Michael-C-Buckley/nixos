# The base I gave to all linux hosts
{
  inputs,
  config,
  ...
}: {
  flake.modules.nixos.linuxPreset = {lib, ...}: {
    imports = with config.flake.modules.nixos;
      [
        programs
        security
        gpg
        nix
        options
      ]
      ++ (with inputs; [
        sops-nix.nixosModules.sops
      ]);

    time.timeZone = lib.mkDefault "America/New_York";
    environment.enableAllTerminfo = true;
    networking.nftables.enable = lib.mkDefault true;
  };
}
