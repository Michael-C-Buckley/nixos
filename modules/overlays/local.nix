{config, ...}: {
  flake.overlays.default = _: prev: {
    inherit
      (config.flake.packages.${prev.system})
      helium
      gpg-find-key
      ns
      nvf
      nvf-copilot
      nvf-minimal
      zeditor
      ;
  };
}
