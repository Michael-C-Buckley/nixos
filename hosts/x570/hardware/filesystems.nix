# Non-disko configurations, for the moment
{
  custom.impermanence = {
    var.enable = false;
    home.enable = false;
  };

  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "4G";
  };

  services.sanoid.datasets = {
    "zroot/x570/nixos/home/michael".use_template = ["normal"];
  };
}
