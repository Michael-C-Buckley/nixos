# Non-disko configurations, for the moment
{
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "4G";
  };

  services.sanoid.datasets = {
    "zroot/michael".use_template = ["normal"];
  };
}
