{ pkgs, ... }: {
  environment.systemPackages =
    # TODO: clean paths up
    (import ../../../packages/lists.nix pkgs).base;
}
