{
  flake.modules.nvf.default = {
    vim.keymaps = [
      {
        # Close buffer
        mode = "n";
        key = "<leader>bd";
        action = ":bd<CR>";
        silent = true;
      }
    ];
  };
}
