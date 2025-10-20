{
  vim.keymaps = [
    {
      mode = "n";
      key = "<leader>cs";
      action = ":Telescope colorscheme<CR>";
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
      key = "<leader>fa";
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
}
