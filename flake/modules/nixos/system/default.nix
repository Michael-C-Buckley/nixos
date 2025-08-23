_: {
  imports = [
    ./boot.nix
    ./builder.nix
    ./nix.nix
    ./options.nix
    ./relink.nix
    ./risks.nix
    ./users
  ];

  time.timeZone = "America/New_York";
  environment.enableAllTerminfo = true;
}
