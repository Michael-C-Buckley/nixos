{config, ...}: {
  imports = [
    ./containerd.nix
    ./options.nix
    ./packages.nix
  ];

  services.kubernetes = {
    easyCerts = true; # requires cfssl package
    addons.dns = {
      enable = true;
      corefile = ''
        .:10053 {
          errors
          health :10054
          kubernetes ${config.services.kubernetes.addons.dns.clusterDomain} in-addr.arpa ip6.arpa {
            pods insecure
            fallthrough in-addr.arpa ip6.arpa
          }
          prometheus :10055
          forward . 192.168.65.1
          cache 30
          loop
          reload
          loadbalance
        }
      '';
    };
    flannel.enable = true;
    kubelet.extraOpts = "--fail-swap-on=false";
  };
}
