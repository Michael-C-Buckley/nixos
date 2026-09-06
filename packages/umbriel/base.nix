{
  extraConfig ? { },
}:
{
  general = {
    autostart = [ ];
    xwayland = true;
    show_cheatsheet = false;
    focus_on_activate = false;
    honor_restored_maximize = false;
  };

  workspaces.back_and_forth = false;
  overview.zoom = 0.5;

  appearance = {
    prefer_no_csd = true;
    border_width = 2;
    outer_border_width = 0;
    corner_radius = 10;

    blur = {
      enabled = true;
      optimized = true;
      passes = 3;
      radius = 3;
      noise = 0.02;
      brightness = 0.9;
      contrast = 0.9;
      saturation = 1.1;
    };

    shadow = {
      enabled = true;
      softness = 10;
      offset_x = 2;
      offset_y = 2;
    };
  };

  layout = {
    mode = "dwindle";
    gap = 8;
    width_presets = [
      0.333
      0.5
      0.667
    ];

    scrolling = {
      default_width_fraction = 0.5;
      center_underfull_strip = true;
    };
  };

  input = {
    focus.follows_mouse = true;
    middle_click_paste = true;
    touchpad.tap = true;
    tablet.enabled = true;

    keyboard = {
      layout = "us";
      variant = "";
      options = "";
      repeat_rate = 25;
      repeat_delay = 600;
    };

    mouse = {
      sensitivity = 0.4;
      scroll_wheel_step = 60;
    };

    cursor = {
      theme = "nordzy-cursor-white";
      size = 24;
      hardware_cursor = true;
      hide_when_typing = true;
      hide_timeout_ms = 1000;
    };
  };

  window_rule = [
    {
      blur = true;
      blur_optimized = true;
    }
    {
      match.app_id = "^dev.noctalia.Noctalia$";
      default_floating = true;
      default_size = [
        1020
        900
      ];
    }
    {
      match.app_id = "^dev.noctalia.UmbrielSharePicker$";
      default_floating = true;
      default_size = [
        800
        600
      ];
    }
  ];

  layer_rule = [
    {
      match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$";
      blur = true;
      blur_ignore_alpha = 0.5;
    }
  ];
}
// extraConfig
