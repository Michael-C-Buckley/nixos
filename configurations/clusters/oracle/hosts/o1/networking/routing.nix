_: {
  # Default NixOS will have standard priority, force to override
  # environment.etc."frr/frr.conf".source = lib.mkForce config.age.secrets.frr.path;
}
