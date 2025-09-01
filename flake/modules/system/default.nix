_: {
  imports = [
    ./boot.nix
    ./mime.nix
    ./nix.nix
    ./options.nix
    ./relink.nix
    ./users
  ];

  time.timeZone = "America/New_York";
  environment.enableAllTerminfo = true;
}
