{
  vim = {
    autocomplete.blink-cmp.enable = true;
    statusline.lualine.enable = true;
    telescope.enable = true;
    navigation.harpoon.enable = true;
    useSystemClipboard = true;

    projects.project-nvim.enable = true;

    theme = {
      enable = true;
      name = "nord";
      style = "dark";
    };

    languages = {
      enableLSP = true;
      enableTreesitter = true;

      nix.enable = true;
      rust.enable = true;
      python.enable = true;
    };

    utility = {
      oil-nvim.enable = true;
    };

    keymaps = import ./keymaps.nix;
  };
}
