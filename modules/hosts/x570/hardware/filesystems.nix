# Non-disko configurations, for the moment
{
  flake.modules.nixos.x570 = {
    # Temporary change to ensure proper ownership
    # Will be removed on next install
    users.users = {
      michael.uid = 1000;
      shawn.uid = 1001;
    };

    custom.impermanence = {
      var.enable = false;
      home.enable = false;
    };

    services.sanoid.datasets = {
      "zroot/x570/nixos/persist".use_template = ["normal"];
      "zroot/x570/nixos/home/michael".use_template = ["normal"];
    };
  };
}
