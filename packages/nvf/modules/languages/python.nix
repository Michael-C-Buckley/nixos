{
  flake.modules.nvf.python = {pkgs, ...}: {
    vim = {
      extraPackages = [pkgs.ty];
      extraPlugins.ty = {
        package = pkgs.ty;
        setup = ''
          vim.lsp.enable('ty')
        '';
      };
      languages.python = {
        enable = true;
        dap.enable = true;
        format.enable = true;
        lsp = {
          enable = true;
        };
        treesitter.enable = true;
      };
    };
  };
}
