# The base I gave to all linux hosts
{inputs, ...}: {
  flake.nixosModules.linuxPreset = {
    imports = with inputs.self.nixosModules; [
      programs
      security
      gpg
      nix
    ];

    time.timeZone = "America/New_York";
    environment.enableAllTerminfo = true;
  };
}
