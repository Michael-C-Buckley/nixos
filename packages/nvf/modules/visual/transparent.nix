{
  flake.modules.nvf.transparent = {pkgs, ...}: {
    vim = {
      startPlugins = with pkgs.vimPlugins; [
        transparent-nvim
      ];
      keymaps = [
        {
          mode = "n";
          key = "<leader>tt";
          action = ":TransparentToggle<CR>";
        }
      ];
    };
  };
}
