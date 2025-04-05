{self}: let
  systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];

  nvf = builtins.listToAttrs (map (system: {
      name = system;
      value = {
        nvf = (
          (self.inputs.nvf.lib.neovimConfiguration {
            pkgs = import self.inputs.nixpkgs {inherit system;};
            modules = [../modules/editors/nvf/config];
          })
          .neovim
        );
      };
    })
    systems);
in
  nvf
