# NVF specifically for use with vscode-neovim extension
{
  imports = [
    ./vim.nix
  ];

  vim = {
    autopairs.nvim-autopairs.enable = true;
  };
}
