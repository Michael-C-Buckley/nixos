_: {
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
      key = "<leader>ff";
      action = ":Telescope find_files find_command=rg,--ignore,--hidden,--files<CR>";
      silent = true;
    }
    {
      mode = "n";
      key = "<leader>fh";
      action = ":Telescope help_tags<CR>";
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
  ];
}
