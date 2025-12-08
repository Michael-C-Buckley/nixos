{config, ...}: {
  flake.modules.nixos.p520 = {
    imports = [config.flake.modules.nixos.k3s];
  };
}
