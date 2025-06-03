{inputs, ...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    packages = {
      # keep-sorted start
      ns = pkgs.callPackage ./ns {};
      nvf = pkgs.callPackage ./nvf {inherit inputs;};
      nvf-minimal = config.packages.nvf.override {is-extended-version = false;};
      # keep-sorted end
    };
  };
}
