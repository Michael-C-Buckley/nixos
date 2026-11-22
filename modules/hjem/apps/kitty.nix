{
  configPaths,
  ...
}:
{
  xdg.config.files = {
    "kitty/kitty.conf".source = configPaths.kitty + "/kitty.conf";
    "kitty/tab_bar.py".source = configPaths.kitty + "/tab_bar.py";
  };
}
