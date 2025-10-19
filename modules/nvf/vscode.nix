# NVF specifically for use with vscode-neovim extension
{
  flake.modules.nvf.vscode = {
    vim = {
      autopairs.nvim-autopairs.enable = true;
    };
  };
}
