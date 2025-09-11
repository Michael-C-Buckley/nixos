{
  imports = [
    ./keymaps
    ./languages
    ./plugins
    ./themes
    ./ui.nix
  ];

  vim = {
    # Utility
    autopairs.nvim-autopairs.enable = true;

    notes = {
      todo-comments.enable = true;
    };

    #Clipboard
    clipboard = {
      enable = true;
      registers = "unnamedplus";
    };

    utility = {
      mkdir.enable = true;
      nix-develop.enable = true;
      oil-nvim.enable = true;
    };

    treesitter = {
      enable = true;
      context.enable = true;
      fold = true;
    };

    git = {
      enable = true;
      git-conflict.enable = true;
      gitsigns.enable = true;
    };

    terminal = {
      toggleterm = {
        enable = true;
        lazygit.enable = true;
      };
    };

    lsp.enable = true;
  };
}
