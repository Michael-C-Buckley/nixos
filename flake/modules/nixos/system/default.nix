_: {
  imports = [
    ./boot.nix
    ./hardware.nix
    ./nix.nix
    ./options.nix
    ./risks.nix
    ./security.nix
    ./users
  ];

  time.timeZone = "America/New_York";
  environment.enableAllTerminfo = true;
}
