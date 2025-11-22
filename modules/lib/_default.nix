{lib, ...}: {
  ips = import ./_ips.nix {inherit lib;};
  wireguard = import ./_wireguard.nix {inherit lib;};
  kube = import ./_kube.nix {inherit lib;};
}
