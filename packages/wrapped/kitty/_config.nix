{
  pkgs,
  extraConfig,
  extraBinds,
}: let
  configAttrs =
    {
      allow_remote_control = "yes";
      bold_font = "auto";
      bold_italic_font = "auto";
      copy_on_select = "yes";
      cursor_blink_interval = "0.5";
      cursor_shape = "block";
      cursor_stop_blinking_after = "15.0";
      enable_audio_bell = "no";
      enabled_layouts = "fat:bias=75;full_size=1;mirrored=false";
      font_family = "Cascadia Code NF";
      font_size = "11.0";
      initial_window_height = "768";
      initial_window_width = "1024";
      italic_font = "auto";
      macos_show_window_title_in = "all";
      macos_titlebar_color = "background";
      mouse_map = "left click ungrabbed,grabbed mouse_select_command";
      remember_window_size = "yes";
      scrollback_lines = "10000";
      strip_trailing_spaces = "smart";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      url_style = "single";
      visual_bell_duration = "0.1";
      window_padding_width = "10";
    }
    // extraConfig;
  bindAttrs =
    {
      "ctrl+shift+alt+t" = "set_tab_title";
      "ctrl+shift+enter" = "new_window_with_cwd";
      "ctrl+shift+left" = "previous_window";
      "ctrl+shift+n" = "new_os_window";
      "ctrl+shift+o" = "open_url_with_hints";
      "ctrl+shift+l" = "next_tab";
      "ctrl+shift+h" = "previous_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+right" = "next_window";
      "ctrl+shift+t" = "new_tab_with_cwd";
      "ctrl+shift+w" = "close_window";
    }
    // extraBinds;
  configText = pkgs.lib.concatStringsSep "\n" (
    (pkgs.lib.mapAttrsToList (name: value: "${name} ${value}") configAttrs)
    ++ (pkgs.lib.mapAttrsToList (name: value: "map ${name} ${value}") bindAttrs)
  );
in
  pkgs.writeText "wrapped-kitty.conf" configText
