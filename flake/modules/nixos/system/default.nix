_: {
  imports = [
    ./boot.nix
    ./builder.nix
    ./hardware.nix
    ./nix.nix
    ./options.nix
    ./risks.nix
    ./users
  ];

  time.timeZone = "America/New_York";
  environment.enableAllTerminfo = true;
}
