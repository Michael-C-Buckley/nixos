{self}: let
  inherit (self.inputs) nvf nixpkgs;
  systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
  forAllSystems = nixpkgs.lib.genAttrs systems;

  sysCfg = self.outputs.nixosConfigurations;

  mkNvf = system: extraModules: (
    (nvf.lib.neovimConfiguration {
      pkgs = import nixpkgs {inherit system;};
      modules = [./nvf/config/default.nix] ++ extraModules;
    }).neovim
  );
in
  forAllSystems (system: {
    nvf-default = mkNvf system [./nvf/config/extended.nix];
    nvf-minimal = mkNvf system [];
    vm = sysCfg.vm.config.system.build.diskoImagesScript;
    o3 = sysCfg.o3.config.system.build.diskoImagesScript;
  })
