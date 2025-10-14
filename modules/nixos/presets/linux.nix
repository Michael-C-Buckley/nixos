# The base I gave to all linux hosts
{inputs, ...}: {
  flake.nixosModules.linuxPreset = {
    imports = with inputs.self.nixosModules;
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
