_: {
  imports = [
    ./containerd.nix
    ./coredns.nix
    ./options.nix
    ./packages.nix
  ];

  services.kubernetes = {
    easyCerts = true; # requires cfssl package
    flannel.enable = true;
    kubelet.extraOpts = "--fail-swap-on=false";
  };
}
