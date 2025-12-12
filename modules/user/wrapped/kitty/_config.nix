{pkgs}:
pkgs.writeText "wrapped-kitty.conf" ''
  allow_remote_control yes
  bold_font auto
  bold_italic_font auto
  copy_on_select yes
  cursor_blink_interval 0.5
  cursor_shape block
  cursor_stop_blinking_after 15.0
  enable_audio_bell no
  enabled_layouts fat:bias=75;full_size=1;mirrored=false
  font_family Cascadia Code NF
  font_size 11.0
  initial_window_height 768
  initial_window_width 1024
  italic_font auto
  macos_show_window_title_in all
  macos_titlebar_color background
  mouse_map left click ungrabbed,grabbed mouse_select_command
  remember_window_size yes
  scrollback_lines 10000
  strip_trailing_spaces smart
  tab_bar_style powerline
  tab_powerline_style slanted
  url_style single
  visual_bell_duration 0.1
  window_padding_width 10
''
