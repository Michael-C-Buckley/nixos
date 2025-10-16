# The base I gave to all linux hosts
{inputs, ...}: {
  flake.modules.nixos.linuxPreset = {
    imports = with inputs.self.modules.nixos;
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

    time.timeZone = "America/New_York";
    environment.enableAllTerminfo = true;
  };
}
