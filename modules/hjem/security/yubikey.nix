{ pkgs, ... }:
{
  packages = (import ../../../packages/lists.nix pkgs).yubikey;
}
