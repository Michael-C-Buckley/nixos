_: {
  flake.userModules = {
    # keep-sorted start
    appearance-cursor = import ./appearance/cursor.nix;
    appearance-gtk = import ./appearance/gtk.nix;
    environment-gnupg = import ./environment/gnupg.nix;
    options = import ./options;
    programs = import ./programs;
    # keep-sorted end
  };
}
