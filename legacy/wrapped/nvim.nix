# Simple wrapper to put the development deps I use into the path
# Actual config is managed externally as part of my normal home
{
  perSystem = {pkgs, ...}: let
    runtimeEnv = pkgs.buildEnv {
      name = "nvim-runtime-env";
      pathsToLink = ["/bin"];
      paths = with pkgs; [
        # General
        git
        lazygit

        # Nix
        nil
        nixd
        alejandra

        # Lua
        lua-language-server
        stylua

        # Python
        basedpyright
        ruff

        # Json
        vscode-json-languageserver
      ];
    };
  in {
    packages.nvim = pkgs.symlinkJoin {
      name = "nvim";
      paths = [pkgs.neovim];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/nvim \
         --prefix PATH : ${runtimeEnv}/bin
      '';
    };
  };
}
