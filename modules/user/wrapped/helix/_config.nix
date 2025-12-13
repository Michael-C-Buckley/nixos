{
  pkgs,
  extraConfig,
}:
pkgs.writeText "helix-wrapped-config" ''
  theme = "ayu_dark"

  [editor]
  line-number = "relative"

  [editor.cursor-shape]
  insert = "bar"
  normal = "block"
  select = "underline"

  [editor.file-picker]
  hidden = false
  ${extraConfig}
''
