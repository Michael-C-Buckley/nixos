{
  pkgs,
  inputs,
}: let
  config = {
    vim = {
      autopairs.nvim-autopairs.enable = true;
      notes.todo-comments.enable = true;
      comments.comment-nvim.enable = true;
      utility.motion.leap.enable = true;
    };
  };
in
  (inputs.nvf.lib.neovimConfiguration
    {
      inherit pkgs;
      modules = [config];
    }).neovim
