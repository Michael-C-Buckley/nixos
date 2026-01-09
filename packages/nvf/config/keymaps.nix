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
      {
        # Remove F1 for help
        mode = ["n" "i" "v"];
        key = "<F1>";
        action = "<Nop>";
        silent = true;
      }
    ];
  };
}
