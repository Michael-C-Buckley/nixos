# NVF specifically for use with vscode-neovim extension
{
  flake.modules.nvf.vscode = {
    vim = {
      autopairs.nvim-autopairs.enable = true;
      autocomplete.blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;
      };
    };
  };
}
