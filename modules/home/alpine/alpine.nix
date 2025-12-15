{
  flake.modules.homeManager.alpine = {
    home.stateVersion = "25.11";
    home.sessionVariables = {
      COLORTERM = "truecolor";
    };
  };
}
