{self}: let
  inherit (self.inputs) nvf nixpkgs;
  # Disko VM images
  systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];

  mkNvf = system: extraModules: (
    (nvf.lib.neovimConfiguration {
      pkgs = import nixpkgs {inherit system;};
      modules = [./packages/nvf/config/default.nix] ++ extraModules;
    })
            .neovim
  );

  mkDiskoImage = system:
  # Only build X86 for now:
    if system == "x86_64-linux"
    then {
      vm = self.outputs.nixosConfigurations.vm.config.system.build.diskoImagesScript;
      o3 = self.outputs.nixosConfigurations.o3.config.system.build.diskoImagesScript;
    }
    else {};
in
  # Build the NVF
  builtins.listToAttrs (map (system: {
      name = system;
      value =
        {
          nvf-default = mkNvf system [./packages/nvf/config/extended.nix];
          nvf-minimal = mkNvf system [];
        }
        // mkDiskoImage system;
    })
    systems)
