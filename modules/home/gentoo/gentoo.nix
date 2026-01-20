{
  flake.modules.homeManager.gentoo = {
    home.stateVersion = "25.11";
    home.sessionVariables = {
      COLORTERM = "truecolor";
    };
  };
}
