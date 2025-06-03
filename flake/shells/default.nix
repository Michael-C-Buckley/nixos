_: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devShells = {
      # keep-sorted start
      default = config.devShells.development;
      development = pkgs.callPackage ./development.nix {};
      # keep-sorted end
    };
  };
}
