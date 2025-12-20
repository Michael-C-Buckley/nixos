{
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
