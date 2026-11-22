{
  services = {
    chrony.enable = true;
    timesyncd.enable = false;
  };
  time = {
    timeZone = "America/New_York";
    hardwareClockInLocalTime = false;
  };
}
