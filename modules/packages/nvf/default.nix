{config, ...}: {
  flake.modules.nvf.default = {
    imports = with config.flake.modules.nvf; [
      keymaps
      languages
      nix
      plugins
      themes
      ui
      vim
    ];

    vim = {
      autopairs.nvim-autopairs.enable = true;

      notes = {
        todo-comments.enable = true;
      };

      clipboard = {
        enable = true;
        registers = "unnamedplus";
      };

      utility = {
        outline.aerial-nvim.enable = true;
        mkdir.enable = true;
        nix-develop.enable = true;
        oil-nvim.enable = true;
        motion.leap.enable = true;
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

      lsp = {
        enable = true;
        formatOnSave = true;
      };

      autocomplete.blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;
      };
    };
  };
}
