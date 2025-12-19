{
  pkgs,
  extraConfig,
}:
pkgs.writeText "ghostty-wrapped-config" ''
  theme = Wombat
  background = #000000
  cursor-color = #44A3A3
  cursor-opacity = 0.6
  font-family = Cascadia Code NF
  font-size = 11
  window-theme = system
  ${extraConfig}
''
