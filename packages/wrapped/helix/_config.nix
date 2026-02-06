{pkgs}:
pkgs.writers.writeTOML "helix-config" {
  theme = "ayu_dark";
  editor = {
    line-number = "relative";
    bufferline = "multiple";
    cursorline = true;
    true-color = true;
    rulers = [120];
    end-of-line-diagnostics = "hint";

    inline-diagnostics = {
      cursor-line = "error";
      other-lines = "disable";
    };

    cursor-shape = {
      insert = "bar";
      normal = "block";
      select = "underline";
    };

    file-picker.hidden = false;

    indent-guides = {
      character = "╎";
      render = true;
    };
  };

  keys = {
    normal = {
      "A-," = "goto_previous_buffer";
      "A-." = "goto_next_buffer";
      A-w = ":buffer-close";
      A-x = "extend_to_line_bounds";
      A-r = ":reload-all";
      X = "select_line_above";
    };
    select = {
      A-x = "extend_to_line_bounds";
      X = "select_line_above";
    };
  };
}
