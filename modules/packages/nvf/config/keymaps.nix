{
  flake.modules.nvf.keymaps = {
    vim.keymaps = [
      {
        mode = "n";
        key = "<leader>cs";
        action = ":Telescope colorscheme enable_preview=true<CR>";
        silent = true;
      }
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
        action = ":Telescope undo<CR>";
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
    ];
  };
}
