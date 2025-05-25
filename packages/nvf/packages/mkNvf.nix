system: extraModules: (
    (nvf.lib.neovimConfiguration {
      pkgs = import nixpkgs {inherit system;};
      modules = [../config/default.nix] ++ extraModules;
    }).neovim
  )