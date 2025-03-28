{config, lib, ...} : {
  # Default Nixos will have standard priority, force to override
  environment.etc."frr/frr.conf".source = lib.mkForce config.age.secrets.frr.path;

  services.frr = {
    bgpd.enable = true;
    eigrpd.enable = true;
    ospfd.enable = true;
    bgpd.options = [ "--limit-fds 2048" ];
    zebra.options = [ "--limit-fds 2048" ];
    openFilesLimit = 2048;
  };
}
