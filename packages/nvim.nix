{
  pkgs,
  extraParsers ? [ ],
  ...
}:
pkgs.neovim.override {
  configure = {
    packages.treesitter.start = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (
        p:
        with p;
        [
          bash
          diff
          go
          json
          lua
          markdown
          markdown_inline
          nix
          nu
          python
          query
          rust
          toml
          vim
          vimdoc
          yaml
          yang
        ]
        ++ extraParsers
      ))
    ];

    customLuaRC = ''
      vim.g.nix_treesitter = true
      dofile(vim.fn.stdpath("config") .. "/init.lua")
    '';
  };
}
