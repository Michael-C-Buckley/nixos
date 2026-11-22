{
  lib,
  pkgs,
  configPaths,
  extraParsers ? [ ],
  ...
}:
let
  # vim.pack installs every plugin in the lockfile on first start, active or
  # not. Nix supplies nvim-treesitter, so leave it out of the seed.
  lock = lib.importJSON (configPaths.nvim + "/nvim-pack-lock.json");
  seedLock = pkgs.writeText "nvim-pack-lock.json" (
    builtins.toJSON (lock // { plugins = removeAttrs lock.plugins [ "nvim-treesitter" ]; })
  );
in
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

    customLuaRC =
      # lua
      ''
        vim.loader.enable()
        vim.g.nix_treesitter = true

        -- Seed a writable lockfile once; preserve subsequent local updates.
        local config_dir = vim.fn.stdpath("config")
        local lock_path = config_dir .. "/nvim-pack-lock.json"
        if vim.fn.filereadable(lock_path) == 0 then
          vim.fn.mkdir(config_dir, "p")
          local seed = "${seedLock}"
          assert(
            vim.fn.writefile(vim.fn.readfile(seed), lock_path) == 0,
            "Failed to initialize Neovim package lockfile"
          )
        end
      ''
      + builtins.readFile (configPaths.nvim + "/init.lua");
  };
}
