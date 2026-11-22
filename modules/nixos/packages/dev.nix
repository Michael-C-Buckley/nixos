{ pkgs, ... }:
{
  # TODO: clean paths up
  environment.systemPackages = (import ../../../packages/lists.nix pkgs).dev;
}
