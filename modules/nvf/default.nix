{self, ...}: {
  flake.modules.nvf.default = {
    imports = with self.modules.nvf; [
      keymaps
      languages
      nix
      plugins
      themes
      ui
    ];

    vim = {
      options = {
        matchtime = 2; # briefly jump to a matching bracket for 0.2s
        exrc = true; # use project specific vimrc
        smartindent = true;
        softtabstop = 4;
        tabstop = 4;
        shiftwidth = 4;
        expandtab = true;
        shiftround = true; # round indent to multiple of 'shiftwidth' for > and < command
      };

      lineNumberMode = "relNumber";
      preventJunkFiles = true;
      searchCase = "smart";

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
