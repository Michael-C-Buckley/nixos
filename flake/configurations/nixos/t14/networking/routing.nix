{
  config,
  lib,
  ...
}: {
  # Default Nixos will have standard priority, force to override
  environment.etc."frr/frr.conf".source = lib.mkForce config.sops.secrets.frr.path;

  networking = {
    bgp.enable = true;
    eigrp.enable = true;
    ospf.enable = true;
  };
}
