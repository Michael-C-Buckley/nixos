let
  mkFzfBind = keys: action: {
    mode = "n";
    key = "<leader>${keys}";
    action = ":FzfLua ${action}<CR>";
  };
in {
  flake.modules.nvf.keymaps = {
    vim.keymaps = [
      {
        # Close buffer
        mode = "n";
        key = "<leader>bd";
        action = ":bd<CR>";
        silent = true;
      }
      {
        mode = "n";
        key = "<leader>lf";
        action = ":lua vim.lsp.buf.format()<CR>";
        silent = true;
      }
      {
        mode = "n";
        key = "<leader>fu";
        action = ":FzfLua undo<CR>";
      }
      {
        mode = "n";
        key = "<leader>nt";
        action = ":Neotree toggle<CR>";
      }
      {
        mode = "n";
        key = "<leader>tt";
        action = ":TransparentToggle<CR>";
      }
      (mkFzfBind "ff" "files")
      (mkFzfBind "fg" "live_grep")
      (mkFzfBind "fr" "resume")
      (mkFzfBind "cs" "colorschemes")
      (mkFzfBind "gs" "git_status")
      (mkFzfBind "gd" "git_diff")
      (mkFzfBind "gb" "git_branches")
    ];
  };
}
