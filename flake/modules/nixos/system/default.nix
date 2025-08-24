_: {
  imports = [
    ./boot.nix
    ./builder.nix
    ./options.nix
    ./relink.nix
    ./users
  ];

  time.timeZone = "America/New_York";
  environment.enableAllTerminfo = true;
}
