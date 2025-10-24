# NVF specifically for use with vscode-neovim extension
{config, ...}: {
  flake.modules.nvf.vscode = {
    imports = with config.flake.modules.nvf; [
      vim
    ];

    vim = {
      autopairs.nvim-autopairs.enable = true;
    };
  };
}
