_: {
  # Following along at: https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/cluster/k3s/docs/USAGE.md
  networking.firewall = {
    allowedTCPPorts = [6443 2379 2380];
    allowedUDPPorts = [8472];
  };

  services.k3s = {
    role = "server";
  };
}
