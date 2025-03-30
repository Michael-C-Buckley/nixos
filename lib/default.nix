{
  lib,
  pkgs,
  ...
}: {
  wireguardInterface = import ./wireguard-interface.nix {inherit lib pkgs;};
}
