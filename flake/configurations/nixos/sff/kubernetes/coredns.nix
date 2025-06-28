{config, ...}: let
  kubeDNS = config.services.kubernetes.addons.dns;
  inherit (config.custom) kube;
in {
  services.kubernetes.addons.dns = {
    enable = true;
    # WIP: expand options set
    corefile = ''
      .:10053 {
        errors
        health :10054
        kubernetes ${kubeDNS.clusterDomain} in-addr.arpa ip6.arpa {
          pods insecure
          fallthrough in-addr.arpa ip6.arpa
        }
        prometheus :10055
        forward . ${kube.dns.forwardAddr}
        cache 30
        loop
        reload
        loadbalance
      }
    '';
  };
}
