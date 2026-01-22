{
  flake.modules.homeManager.alpine = {
    custom.systemd.use = false;
    home.stateVersion = "25.11";
    home.sessionVariables = {
      COLORTERM = "truecolor";
    };
  };
}
