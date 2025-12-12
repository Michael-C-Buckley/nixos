{
  pkgs,
  extraConfig,
}:
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
  map ctrl+shift+alt+t set_tab_title
  map ctrl+shift+enter new_window_with_cwd
  map ctrl+shift+left previous_window
  map ctrl+shift+n new_os_window
  map ctrl+shift+o open_url_with_hints
  map ctrl+shift+page_down next_tab
  map ctrl+shift+page_up previous_tab
  map ctrl+shift+q close_tab
  map ctrl+shift+right next_window
  map ctrl+shift+t new_tab_with_cwd
  map ctrl+shift+w close_window
''
+ extraConfig
