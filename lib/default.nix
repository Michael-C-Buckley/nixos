{
  lib,
  pkgs,
  ...
}: {
  wireguardInterface = import ./wireguard-interface.nix {inherit lib pkgs;};
  mkAddress = import ./address.nix {inherit lib;};
}
