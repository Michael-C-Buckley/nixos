# NVF specifically for use with vscode-neovim extension
{
  flake.modules.nvf.vscode = {
    imports = [
      ./vim.nix
    ];

    vim = {
      autopairs.nvim-autopairs.enable = true;
    };
  };
}
