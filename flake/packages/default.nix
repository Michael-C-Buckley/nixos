{
  self,
  inputs,
  ...
}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    packages = {
      # keep-sorted start
      ns = pkgs.callPackage ./ns.nix {};
      nvf = pkgs.callPackage ./nvf {inherit inputs;};
      nvf-minimal = config.packages.nvf.override {is-extended-version = false;};
      o1 = self.nixosConfigurations.o1.config.system.build.diskoImagesScript;
      # keep-sorted end
    };
  };
}
