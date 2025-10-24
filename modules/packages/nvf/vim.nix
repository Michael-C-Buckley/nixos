# Basic Vim options common to all instances
{
  flake.modules.nvf.vim = {
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
    };
  };
}
