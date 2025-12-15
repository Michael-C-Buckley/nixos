{config, ...}: {
  flake.modules.nvf.default = {
    imports = with config.flake.modules.nvf; [
      keymaps
      plugins
      themes
      ui
      vim
    ];

    vim = {
      # They get kind of annoying
      autopairs.nvim-autopairs.enable = false;

      notes.todo-comments.enable = true;

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
    };
  };
}
