{ pkgs, ... }:
{
  packages = (import ../../../packages/lists.nix pkgs).dev;
}
