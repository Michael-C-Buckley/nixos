{self, ...}: {
  # Just pull the shell.nix from the root
  # This allows both Flake and non-Flake compatibility, odd as it would be
  perSystem = {pkgs, ...}: {
    devShells.default = import "${self}/shell.nix" {inherit pkgs;};
  };
}
