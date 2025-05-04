_: {
  imports = [
    ./boot.nix
    ./hardware.nix
    ./nix.nix
    ./risks.nix
    ./security.nix
    ./users.nix
  ];

  time.timeZone = "America/New_York";
  environment.enableAllTerminfo = true;
}
