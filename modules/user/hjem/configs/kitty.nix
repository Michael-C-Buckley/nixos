{
  flake.hjemConfig.kitty = {
    hjem.users.michael.rum.programs.kitty = {
      enable = true;
      settings = {
        font_family = "Cascadia Code NF";
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
        font_size = "11.0";
        adjust_line_height = "110%";

        cursor_shape = "block";
        cursor_blink_interval = "0.5";
        cursor_stop_blinking_after = "15.0";

        enabled_layouts = "fat:bias=75;full_size=1;mirrored=false";
        remember_window_size = "yes";
        initial_window_width = "1024";
        initial_window_height = "768";
        window_padding_width = "10";
        macos_titlebar_color = "background";
        macos_show_window_title_in = "all";

        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";

        # Key mappings
        "map ctrl+shift+t" = "new_tab_with_cwd";
        "map ctrl+shift+q" = "close_tab";
        "map ctrl+shift+n" = "new_os_window";
        "map ctrl+shift+enter" = "new_window_with_cwd";
        "map ctrl+shift+w" = "close_window";
        "map ctrl+shift+left" = "previous_window";
        "map ctrl+shift+right" = "next_window";
        "map ctrl+shift+page_up" = "previous_tab";
        "map ctrl+shift+page_down" = "next_tab";
        "map ctrl+shift+alt+t" = "set_tab_title";

        allow_remote_control = "yes";
        "map ctrl+shift+o" = "open_url_with_hints";
        scrollback_lines = "10000";
        copy_on_select = "yes";
        mouse_map = "left click ungrabbed,grabbed mouse_select_command";
        url_style = "single";
        strip_trailing_spaces = "smart";

        enable_audio_bell = "no";
        visual_bell_duration = "0.1";
      };
    };
  };
}
